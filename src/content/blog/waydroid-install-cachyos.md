---
title: "CachyOS (Arch) 安装 Waydroid 指南 — 国内环境网络问题排查"
date: 2026-07-11
description: "在 CachyOS (Arch 系) 上安装 Waydroid 的完整流程，包含国内环境镜像加速方案和 ufw + nftables 网络冲突排查。"
tags: ["linux", "waydroid", "arch", "cachyos", "android"]
slug: "waydroid-install-cachyos"
draft: false
---

## 前提条件

- **OS**: CachyOS (Arch 系，滚动更新)
- **Kernel**: 7.x+，内核需启用 `CONFIG_ANDROID_BINDER_IPC=y` 和 `CONFIG_ANDROID_BINDERFS=y`
- **显示**: Wayland 会话 (KDE/GNOME 等)
- **防火墙**: ufw
- **无代理**

用以下命令确认内核支持：

```bash
zcat /proc/config.gz | grep -iE "BINDER|ASHMEM"
```

确保输出中 `BINDER_IPC` 和 `BINDERFS` 为 `y`。

## 安装流程

### 1. 添加 archlinuxcn 源

编辑 `/etc/pacman.conf`，添加：

```
[archlinuxcn]
Server = https://mirrors.tuna.tsinghua.edu.cn/archlinuxcn/$arch
```

> 清华 TUNA 镜像在国内速度稳定。

### 2. 安装核心包

```bash
sudo pacman -S waydroid waydroid-image python-pyclip
```

- `waydroid` — 主程序
- `waydroid-image` — 预编译 LineageOS 镜像 (来自 archlinuxcn 清华源，**国内快速下载**，避免从 SourceForge 拉取)
- `python-pyclip` — 剪贴板桥接 (Android ↔ Linux)

> `waydroid-image` 是关键：官方 `waydroid init` 从海外下载 ~700MB 镜像极慢，而 archlinuxcn 仓库提供预编译镜像，走国内 CDN。

### 3. 挂载 binderfs

```bash
sudo mkdir -p /dev/binderfs
sudo mount -t binder binder /dev/binderfs
echo 'binder /dev/binderfs binder nofail 0 0' | sudo tee -a /etc/fstab
```

验证：

```bash
ls /dev/binderfs/
# 应看到: binder  binder-control  features  hwbinder  vndbinder
```

### 4. 启用 IP 转发

```bash
echo 'net.ipv4.ip_forward = 1' | sudo tee /etc/sysctl.d/99-waydroid.conf
sudo sysctl -p /etc/sysctl.d/99-waydroid.conf
```

### 5. 初始化 Waydroid

```bash
sudo waydroid init -f
```

因为 `waydroid-image` 已安装，`-f` 会使用本地镜像跳过下载。

### 6. 启动服务

```bash
sudo systemctl enable --now waydroid-container
nohup waydroid session start > /dev/null 2>&1 &
```

> `waydroid session start` 会阻塞终端，用 `nohup` 后台运行。

### 7. 验证安装

```bash
waydroid status
# Session: RUNNING
# Container: RUNNING
```

## 网络问题排查

这是最可能遇到坑的地方。以下是在 ufw 环境下的排查过程。

### 问题现象

容器启动后无网络：`ping 8.8.8.8` 返回 `Network is unreachable`，容器内无 IPv4 地址。

### 根因分析

三层问题叠加：

**① ufw FORWARD 策略为 DROP**

```bash
iptables -L FORWARD -n
# Chain FORWARD (policy DROP)
```

Docker 安装后会修改 iptables FORWARD 策略为 DROP，即使 Docker 未运行也残留。

**修复**：

```bash
sudo sed -i 's/DEFAULT_FORWARD_POLICY="DROP"/DEFAULT_FORWARD_POLICY="ACCEPT"/' /etc/default/ufw
sudo ufw reload
```

**② ufw 缺少 DNS/DHCP 放行规则**

```bash
sudo ufw allow 53    # DNS
sudo ufw allow 67    # DHCP
sudo ufw default allow FORWARD
```

**③ waydroid-net.sh 的 nftables 与 ufw 冲突（关键）**

`/usr/lib/waydroid/data/scripts/waydroid-net.sh` 默认 `LXC_USE_NFT="true"`，会同时使用 nftables 和 iptables。ufw 也使用 nftables，两者冲突导致容器拿不到 DHCP 租约。

**修复**：

```bash
sudo sed -i 's/LXC_USE_NFT="true"/LXC_USE_NFT="false"/' \
  /usr/lib/waydroid/data/scripts/waydroid-net.sh
```

> ArchWiki 原文明确提到：「如果没有开启 nftables 服务，记得把 `LXC_USE_NFT` 设置为 `false`，否则会出现 ip 分配正确，但流量发送出去但转发不回来的现象。」

### 完整修复后的网络验证

```bash
# 重启 waydroid
sudo systemctl restart waydroid-container
nohup waydroid session start > /dev/null 2>&1 &

# 检查容器 IP
sudo waydroid shell -- ip addr show eth0
# inet 192.168.240.112/24

# 测试连通性
sudo waydroid shell -- ping -c 2 8.8.8.8      # ✅
sudo waydroid shell -- ping -c 2 baidu.com     # ✅
```

## 多窗口模式

Waydroid 默认全屏运行。要让 Android 应用以独立窗口显示：

```bash
waydroid prop set persist.waydroid.multi_windows true
waydroid session stop
waydroid session start
```

## IPv6 要求

ArchWiki 提到：即使不使用 IPv6，也必须确保系统启用了 IPv6，否则 Waydroid 无法联网。

```bash
cat /proc/sys/net/ipv6/conf/all/disable_ipv6
# 应为 0
```

## 总结

| 步骤 | 状态 |
|---|---|
| pacman 安装 waydroid + waydroid-image + python-pyclip | ✅ |
| binderfs 挂载 + fstab | ✅ |
| sysctl IP 转发 | ✅ |
| ufw FORWARD ACCEPT + 放行 53/67 | ✅ |
| waydroid-net.sh 关闭 nft | ✅ |
| waydroid init -f | ✅ |
| waydroid-container + session 启动 | ✅ |
| 网络连通 | ✅ |

关键经验：国内环境用 archlinuxcn 清华源装 `waydroid-image` 可以避免慢速下载；网络问题的核心是 ufw + nftables 冲突，`LXC_USE_NFT=false` 是关键修复。
