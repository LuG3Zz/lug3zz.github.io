---
title: "最后一次配置 Linux"
date: 2026-05-17
description: "从 CachyOS 安装到 MangoWM + dms 桌面环境，记录了 fcitx5-rime 小鹤双拼、chezmoi dotfiles、oh-my-posh 主题定制、yazi 新版兼容修复、WPS 字体与中文输入等完整配置过程。一切自动化，下次重装不再从头来过。"
tags: ["linux", "dotfiles", "mangowm", "efficiency"]
slug: last-linux-setup
series: "新电脑配置"
seriesOrder: 3
---

每次重装系统都是一次轮回。装软件、调配置、改快捷键、装输入法……同一个坑踩三四次之后，我终于决定：**这次就是最后一次**。

这篇文章记录了我在 CachyOS 上从零搭建桌面环境的完整过程，所有配置都已纳入 chezmoi 管理并推送到 GitHub。下次重装 —— 一条命令恢复。

> [!note]
> 本文是「新电脑配置」系列的第三篇。前两篇分别记录了 [[PC_config|Windows 效率工具]] 和 [[dev-env-restore|开发环境自动化恢复]]，本篇专注 Linux（Arch 系）桌面环境。

---

## 系统选择：CachyOS

选 CachyOS 而不是原版 Arch，理由很简单 —— 开箱即用、内核优化、硬件支持好。它本质上是 Arch Linux，但内置了性能调优内核和更适合桌面用户的默认配置。

```
$ uname -a
Linux cachyos 7.0.8-arch1-1 #1 SMP PREEMPT_DYNAMIC x86_64 GNU/Linux
```

显示管理器？不用。直接 tty 登录，`start` 命令进入 [mango](https://github.com/hyiltiz/mango) —— 一个 wlroots 平铺窗口管理器。

---

## 中文输入法：fcitx5 + RIME + 小鹤双拼

Linux 桌面中文输入一直是老大难。这次一步到位：

```bash
sudo pacman -S fcitx5 fcitx5-rime fcitx5-configtool
```

环境变量配置在 `~/.bash_profile` 和 `~/.config/environment.d/fcitx5.conf`：

```bash
export GTK_IM_MODULE=fcitx
export QT_IM_MODULE=fcitx
export XMODIFIERS=@im=fcitx
export SDL_IM_MODULE=fcitx
```

RIME 配置为 **小鹤双拼（flypy）**，默认输出简体中文：

```yaml
# default.custom.yaml
schema_list:
  - schema: double_pinyin_flypy

# double_pinyin_flypy.custom.yaml
switches/@0/reset: 0   # 默认简体
switches/@2/reset: 1   # 默认简化
```

> [!tip]
> 部署后记得 `fcitx5 -rd` 重新加载，或者重启一下 fcitx5 进程。

---

## 字体：Maple Mono NF CN

等宽字体我选了 **Maple Mono NF CN** —— 完美支持中文 + Nerd Font 图标，圆角造型非常耐看。Alacritty 中设置为 13 号字：

```toml
[font]
size = 13
normal = { family = "Maple Mono NF CN" }
```

> [!note]
> 这个字体在 archlinuxcn 源中，直接用 pacman 安装即可，不需要从 AUR 编译。

---

## Dotfiles：chezmoi + GitHub

所有配置的归宿是 [chezmoi](https://chezmoi.io/)。它像 Git 一样管理你的 `~` 目录：

```bash
chezmoi init https://github.com/LuG3Zz/dotfiles.git
chezmoi diff   # 预览差异
chezmoi apply  # 应用配置
```

目前 chezmoi 管理的配置分为几大类：

| 类别 | 内容 |
|------|------|
| **mango** | WM 核心配置、按键绑定、窗口规则、自启动脚本、dms 子配置 |
| **DankMaterialShell** | dms 主设置（主题、插件、布局参数） |
| **oh-my-posh** | 自定义终端提示符主题 |
| **nvim** | LazyVim 完整配置 |
| **yazi** | 文件管理器含 Dracula 主题（含新版本兼容修复） |
| **zsh** | 模块化 shell 配置 |
| **wps fonts** | 从双系统 Windows 分区复制的核心中文字体 |

---

## 窗口管理器：Mango + dms

Mango 是一个轻量的 wlroots 平铺 WM，配合 dms（DankMaterialShell）提供桌面环境（顶栏、通知、锁屏、截屏等）。一整套下来极其精简 —— 没有 systemd 服务，没有 D-Bus 依赖，纯 Wayland 原生。

### 按键绑定哲学：全 Super

我把所有窗口操作的快捷键前缀统一为 **Super 键**（Win 键），让操作肌肉记忆更一致：

| 操作 | 快捷键 |
|------|--------|
| 打开终端 | `Super + Enter` |
| 启动器 (dms) | `Super + Space` |
| 文件管理器 | `Super + e` |
| 切换窗口焦点 | `Super + h/j/k/l` |
| 交换窗口 | `Super + Shift + h/j/k/l` |
| 移动窗口 | `Super + Ctrl + Shift + 方向` |
| 缩放窗口 | `Super + Ctrl + Alt + 方向` |
| 关闭窗口 | `Super + q` |
| 最大化 / 全屏 | `Super + a` / `Super + f` |
| 浮动切换 | `Super + T` |
| 切换标签 | `Super + 1-9` |
| 移动窗口到标签 | `Super + Shift + 1-9` |
| 锁屏 | `Super + Ctrl + l` |
| 剪贴板 | `Super + v` |
| 切换壁纸 | `Super + w` |
| 隐藏/显示顶栏 | `Super + b` |
| 全局预览 | `Alt + Tab` |
| 按键速查表 | `Super + /` |

> [!tip]
> 速查表用 `Super + /` 呼出，以 scratchpad 形式悬浮显示，随时查看所有绑定，再也不用死记硬背。

### 配置按功能拆分

原始的 `config.conf` 是一个四百多行的庞然大物。我按照功能拆成了独立文件：

```
~/.config/mango/
├── config.conf       ← 入口：source 引用 + exec-once
├── effect.conf       # 模糊、阴影、圆角
├── animation.conf    # 动画曲线与时长
├── tiling.conf       # 平铺布局参数
├── appearance.conf   # 配色方案
├── overview.conf     # 全局预览
├── misc.conf         # 光标、键盘、触控板
├── bind.conf         # 按键绑定
├── rule.conf         # 窗口规则
├── monitor.conf      # 显示器
├── tag.conf          # 标签
└── dms/              # dms 生成的颜色/布局/输出
```

### 自启动脚本

干净到只有三行：

```bash
#!/bin/bash
dms run &
fcitx5 --replace -d &
cliphist store &
```

没有多余的 service 管理，没有厚重的 DE 组件。dms 负责顶栏、通知、壁纸；fcitx5 管输入法；cliphist 管剪贴板历史。

---

## Yazi：新版兼容修复

Yazi 升级到 26.5.6 后，`[filetype]` 配置规则发生了变化 —— 每条规则必须带 `mime` 或 `url`，不能再只用 `name`。

旧配置（来自 ML4W 模板）有几条这样的规则：

```toml
{ name = "*", is = "orphan", bg = "red" },   # 新版报错
{ name = "*/", fg = "blue" },                 # 同样无效
```

修复方案很简单：删掉这几条，换成一个 MIME 通配兜底：

```toml
{ mime = "*/*", fg = "white" },
```

同时 Dracula flavor 主题文件里也有同样的两条规则，一并修了。chezmoi 源码同步更新，以后重装不会踩同一坑。

---

## WPS 字体：双系统配合

WPS Office 在 Linux 上常报「缺少字体」，主要是缺宋体、黑体、楷体、仿宋等 Windows 字体和方正小标宋简体等排版字体。

我的解决方案来自双系统 —— Windows 分区挂载到 `/run/media/brownlu/系统/Windows/Fonts`，直接复制需要的字体到 Linux：

```bash
cp /run/media/brownlu/系统/Windows/Fonts/{simsun.ttc,simhei.ttf,simkai.ttf,simfang.ttf,msyh.ttc,msyhbd.ttc,msyhl.ttc} /usr/share/fonts/msfonts/
```

方正小标宋简体从 WPS 社区字体包中单独下载：

```bash
curl -Lo FZXBSK.TTF https://github.com/Universebenzene/wps-office-fonts/raw/v1.0/FZXBSK.TTF
sudo cp FZXBSK.TTF /usr/share/fonts/msfonts/
```

22 个 Windows 核心字体，一条 `fc-cache` 生效，WPS 不再报缺字。

### WPS 中文输入

WPS 自带的是 Qt 5.12 定制版，不读取系统环境变量。最直接的方法是在 WPS 启动脚本开头硬编码 fcitx5 环境变量：

```bash
# /usr/bin/wps, /usr/bin/et, /usr/bin/wpp 开头插入
export QT_IM_MODULE=fcitx
export GTK_IM_MODULE=fcitx
export XMODIFIERS=@im=fcitx
export SDL_IM_MODULE=fcitx
```

此外 WPS 自带的 Qt IM 插件是 fcitx4 的，需要把系统 fcitx5 插件链接进去：

```bash
sudo ln -sf /usr/lib/qt/plugins/platforminputcontexts/libfcitx5platforminputcontextplugin.so \
  /usr/lib/office6/qt/plugins/platforminputcontexts/
```

两个步骤都做完，WPS 文字/表格/演示全都能用 fcitx5 正常输入中文。

---

## 一键恢复流程

如果明天这台电脑炸了，恢复流程如下：

```bash
# 1. 安装 CachyOS
# 2. 安装基础包
sudo pacman -S chezmoi alacritty fcitx5 fcitx5-rime \
               oh-my-posh zoxide eza fastfetch lazygit \
               ttf-maplemono-nf-cn-unhinted

# 3. 恢复 dotfiles
chezmoi init https://github.com/LuG3Zz/dotfiles.git
chezmoi apply

# 4. WPS 字体（双系统复制 Windows 字体）
cp /run/media/brownlu/系统/Windows/Fonts/{simsun.ttc,simhei.ttf,simkai.ttf,simfang.ttf,msyh.ttc,msyhbd.ttc,msyhl.ttc} /usr/share/fonts/msfonts/
fc-cache -fv

# 5. WPS 中文输入
sudo ln -sf /usr/lib/qt/plugins/platforminputcontexts/libfcitx5platforminputcontextplugin.so \
  /usr/lib/office6/qt/plugins/platforminputcontexts/

# 6. fcitx5 自启动已在 autostart.sh 中
# 7. 重启，登录，开始工作
```

从装系统到生产环境，30 分钟以内。

> [!warning]
> 这里假设你的 GitHub SSH key 已经配置好。如果还没有，先跑 `ssh-keygen` 然后把公钥加到 GitHub 上。

---

## What's Next

这篇文章的绝大部分配置都在 [github.com/LuG3Zz/dotfiles](https://github.com/LuG3Zz/dotfiles) 上了。未来的任何调整只需要 `chezmoi re-add` + `git push`，新机器上 `chezmoi apply` 就能同步。

所以这真的是 **最后一次配置 Linux**。

之后每一次重装 —— 一条命令，一切还原。

```
$ exit
```
