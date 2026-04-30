---
title: "brownlu-blog 系统功能与使用指南"
date: 2026-04-30
description: "终端风格博客系统完整功能介绍与操作手册"
tags: ["guide", "terminal", "blog"]
slug: brownlu-blog-guide
---

## 概述

brownlu-blog 是一个终端风格的个人博客系统，基于 Astro 5 构建，部署在 GitHub Pages。整个界面模拟终端环境，支持命令式导航、主题切换、地图旅行、脚本托管、文件下载等特色功能。

---

## 终端命令

页面顶部的提示符是一个真正的命令行输入框，支持以下命令：

| 命令 | 功能 |
|------|------|
| `help` | 显示可用命令列表 |
| `ls` | 跳转到文章列表 `/blog` |
| `cat &lt;slug&gt;` | 阅读文章，如 `cat hello-world` |
| `cd &lt;path&gt;` | 切换目录，如 `cd blog`、`cd tags`、`cd ..` |
| `whoami` | 关于页面 `/about` |
| `date` | 底部弹出当前时间 |
| `tag &lt;name&gt;` | 按标签浏览，如 `tag astro` |
| `get &lt;script&gt;` | 获取脚本，如 `get hello.sh` |
| `scripts` | 浏览可用脚本 |
| `downloads` | 浏览可下载资源 |
| `travel` | 查看旅行地图 |
| `activity` / `heatmap` | 查看文章发布热力图 |
| `clear` | 刷新页面 |

---

## 主题切换

导航栏右侧下拉框支持 5 种终端配色主题：

- **terminal** — 经典绿色终端
- **catppuccin** — Catppuccin Mocha 紫粉
- **matrix** — Matrix 绿
- **nord** — 蓝灰 Nord
- **gruvbox** — 暖橙 Gruvbox

选择后即时切换，通过 `localStorage` 持久化，刷新页面自动恢复。

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

---

## 标签系统

每篇文章可添加标签。`/tags` 页面显示所有标签及其文章数量，点击标签跳转至 `/tags/&lt;name&gt;` 查看该标签下的所有文章。

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

```bash
npm run dev      # 本地开发
npm run build    # 构建（含类型检查）
git push origin main  # 自动部署到 GitHub Pages
```

GitHub Actions 自动执行构建并部署。
