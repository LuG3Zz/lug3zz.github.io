---
title: "brownlu-blog 系统功能与使用指南"
date: 2026-04-30
description: "终端风格博客系统完整功能介绍与操作手册"
tags: ["guide", "terminal", "blog"]
slug: brownlu-blog-guide
---

## 概述

brownlu-blog 是一个终端风格的个人博客系统，基于 Astro 5 构建，部署在 GitHub Pages。整个界面模拟终端环境，支持命令式导航、Tab 补全、主题切换、Zen 极简模式、旅行地图、脚本托管、文件下载、ASCII 热力图等特色功能。

---

## 终端命令

页面顶部的提示符是一个真正的命令行输入框，支持以下命令：

| 命令 | 功能 |
|------|------|
| `help` | 显示可用命令列表 |
| `ls` | 跳转到文章列表 `/blog` |
| `cat <slug>` | 阅读文章，如 `cat hello-world` |
| `cd <path>` | 切换目录，如 `cd blog`、`cd tags`、`cd ..` |
| `whoami` | 关于页面 `/about` |
| `date` | 底部弹出当前时间 |
| `tag <name>` | 按标签浏览，如 `tag astro` |
| `get <script>` | 获取脚本，如 `get hello.sh` |
| `scripts` | 浏览可用脚本 |
| `downloads` | 浏览可下载资源 |
| `travel` | 查看旅行地图 |
| `activity` / `heatmap` | 查看文章发布热力图 |
| `zen` | 切换极简阅读模式 |
| `clear` | 刷新页面 |

输入命令时按 **Tab** 可自动补全，多个匹配时连续按 Tab 循环选择，高亮后按 Enter 执行。

---

## Zen 极简模式

输入 `zen` 进入极简模式，隐藏导航栏、天气、帮助信息等非内容元素，仅保留提示符和正文，内容垂直居中，适合专注阅读。再次输入 `zen` 恢复。状态持久化，切换页面不闪烁。

---

## 主题切换

导航栏右侧下拉框支持 5 种终端配色主题：

- **terminal** — 经典绿色终端
- **catppuccin** — Catppuccin Mocha 紫粉
- **matrix** — Matrix 绿
- **nord** — 蓝灰 Nord
- **gruvbox** — 暖橙 Gruvbox

选择后即时切换，通过 `localStorage` 持久化，刷新页面自动恢复，切换页面无闪烁。

---

## 文章管理

文章存储在 `src/content/blog/` 目录，使用 Content Collections 自动管理。新增文章只需创建 `.md` 文件并添加 frontmatter：

```yaml
---
title: "文章标题"
date: 2026-04-30
description: "文章描述"
tags: ["tag1", "tag2"]
slug: my-post
---
```

无需手动编辑列表页，首页和 `/blog` 页面自动显示新文章。

### 文章阅读体验

- **大纲侧边栏** — 屏幕宽 >1200px 时左侧显示目录，滚动时高亮当前章节
- **阅读进度条** — 页面顶部 2px 绿色线条，随滚动从 0% 到 100%
- **代码块复制** — hover 代码块右上角出现 `copy` 按钮，一键复制
- **下载原文** — 文章底部 `↓ download .md` 下载原始 markdown 文件

---

## 标签系统

每篇文章可添加标签。`/tags` 页面显示所有标签及其文章数量，点击标签跳转至 `/tags/<name>` 查看该标签下的所有文章。

---

## 旅行地图

`/travel` 页面使用 Leaflet + 高德地图瓦片，在地图上标记访问过的城市。数据文件 `src/data/travel.js`：

```js
{
  city: "Tokyo",
  lat: 35.6762,
  lng: 139.6503,
  date: "2026-05",
  description: "Shibuya",
  images: ["/images/travel/tokyo1.jpg"]
}
```

支持多张图片，标记点击弹窗显示照片。

---

## 脚本托管

脚本文件放在 `public/scripts/` 目录，可通过 `curl -O` 直接下载：

```bash
curl -O https://lug3zz.github.io/scripts/hello.sh
chmod +x hello.sh
./hello.sh
```

`/scripts` 页面列出所有可用脚本。

---

## 文件下载

资源文件放在 `public/downloads/` 目录，支持浏览器下载和 `curl` 获取。`/downloads` 页面列出所有文件及大小。

---

## ASCII 热力图

`/activity` 页面显示当年文章发布频率的 ASCII 热力图，每个格子代表一天，颜色深浅表示文章数量。下方同时展示标签分布的 ASCII 柱状图。点击有活动的格子可直接跳转到当日文章。

---

## 天气

首页右上角显示实时天气，通过 wttr.in API 获取，显示城市、天气状况、温度、湿度和风向风速。

---

## 部署

### 新电脑上搭建

```bash
# 克隆仓库
git clone git@github.com:LuG3Zz/lug3zz.github.io.git
cd lug3zz.github.io

# 安装依赖
npm install

# 本地开发
npm run dev        # 浏览器打开 http://localhost:4321

# 构建（含类型检查）
npm run build

# 推送到 GitHub Actions 自动部署
git push origin main
```

新机器首次使用需配置 Git 和 SSH 密钥：

```bash
git config --global user.name "你的用户名"
git config --global user.email "你的邮箱"
# 生成 SSH 密钥并添加到 GitHub
ssh-keygen -t ed25519 -C "你的邮箱"
cat ~/.ssh/id_ed25519.pub
# 复制输出到 https://github.com/settings/keys
```

### 日常开发

```bash
npm run dev        # 本地预览
# 写文章、改代码...
git add -A
git commit -m "描述改动"
git push origin main   # 自动部署
```

GitHub Actions 自动执行构建并发布到 `https://lug3zz.github.io`。
