---
title: "brownlu-blog 系统功能与使用指南"
date: 2026-04-30
description: "终端风格博客系统完整功能介绍与操作手册"
tags: ["guide", "terminal", "blog"]
slug: brownlu-blog-guide
pinned: true
image: /images/cover-test.png
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
| `cd <path>` | 切换目录，如 `cd blog`、`cd tags`、`cd search` |
| `whoami` | 关于页面 `/about` |
| `date` | 底部弹出当前时间 |
| `tag <name>` | 按标签浏览，如 `tag astro` |
| `series` | 按系列浏览，如 `series 系列名` |
| `grep <query>` | 全文搜索，结果直接显示在当前页面 |
| `fortune` | 随机显示一句编程格言 |
| `get <script>` | 获取脚本，如 `get hello.sh` |
| `scripts` | 浏览可用脚本 |
| `downloads` | 浏览可下载资源 |
| `travel` | 查看旅行地图 |
| `activity` | 博客统计 + 发布热力图 |
| `archive` | 按年/月归档文章 |
| `zen` | 切换极简阅读模式 |
| `clear` | 刷新页面 |

输入命令时按 **Tab** 可自动补全。支持命令补全和参数补全：
- `c` + Tab → 补全为 `cat` / `cd` / `clear`，连续 Tab 循环选择
- `cat he` + Tab → 补全为 `cat hello-world`
- `tag ` + Tab → 列出所有标签
- `cd ` + Tab → 列出所有可切换目录
- `get ` + Tab → 列出所有脚本名
- `series ` + Tab → 列出所有系列名

补全数据在构建时自动生成，新增文章/标签/脚本后自动更新。

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

### 写作流

推荐的工作流程：

```bash
npm run dev        # 启动本地开发服务器
```

在 `src/content/blog/` 下创建 `.md` 文件，frontmatter 完整字段：

```yaml
---
title: "文章标题"
date: 2026-05-01
description: "简短描述"
tags: ["tag1", "tag2"]
slug: my-post
series: "系列名"       # 可选，所属系列
seriesOrder: 1         # 可选，系列内序号
pinned: true           # 可选，设为 true 置顶
image: /images/cover.jpg  # 可选，封面图
---
```

写作时浏览器打开 `http://localhost:4321` 实时预览。完成后：

```bash
npm run build        # 类型检查 + 构建，确保无报错
git add -A
git commit -m "add: 新文章 my-post"
git push origin main # 自动部署到 GitHub Pages
```

> 提示：希望用 AI 协助写作时，可参考 `AGENTS.md` 了解项目结构与约定，让 AI 更快理解系统。

### 插入图片

图片文件放在 `public/images/` 目录下，在 markdown 中直接用相对路径引用：

```markdown
![图片描述](/images/example.jpg)
```

推荐使用 WebP 格式以减小体积。路径以 `/` 开头，对应 `public/` 目录下的文件。多张图片可建子目录管理，如 `/images/travel/`。

### 文章封面图

在 frontmatter 设置 `image: /images/cover.jpg` 即可为文章添加封面图：

```yaml
---
image: /images/cover.jpg
---
```

- **详情页** — 封面以通栏 banner 形式展示在文章上方，底部渐隐融入背景
- **列表页** — 每篇文章左侧显示 36×36 缩略图（无封面则显示 📄 emoji）

### 文章置顶

在 frontmatter 设置 `pinned: true` 即可将文章置顶。置顶文章在首页和 `/blog` 列表排在最前，并显示黄色 `[Pinned]` 标识。多个置顶文章之间按日期排序。

### 文章阅读体验

- **封面 banner** — 有封面图的文章顶部显示通栏渐隐 banner
- **大纲侧边栏** — 屏幕宽 >1200px 时左侧显示固定目录，滚动时高亮当前章节
- **移动端折叠目录** — 手机等窄屏设备上，正文前会出现一个 `[+] Index` 折叠面板，点击展开/收起目录，点击链接后自动收起
- **阅读进度条** — 页面顶部 2px 绿色线条，随滚动从 0% 到 100%
- **代码块复制** — hover 代码块右上角出现 `copy` 按钮，一键复制
- **下载原文** — 文章底部 `↓ download .md` 下载原始 markdown 文件
- **返回顶部** — 右下角 `^` 按钮，滚动后出现，点击平滑回到顶部

---

## 标签系统

每篇文章可添加标签。`/tags` 页面显示所有标签及其文章数量，点击标签跳转至 `/tags/<name>` 查看该标签下的所有文章。

---

## 文章系列

文章可通过 `series` 和 `seriesOrder` 字段归入系列。同一系列的文章在 `/series/<系列名>` 按顺序展示，文章底部显示上/下篇导航链接。

```yaml
---
series: "Astro 入门"
seriesOrder: 2
---
```

---

## 全文搜索

支持两种搜索方式：

- **命令面板** — 输入 `grep <关键词>` 直接在当前页面搜索，结果以内联面板展示（最多 5 条），点击结果直达文章。超出 5 条显示跳转 `/search` 页面的链接
- **搜索页** — `/search` 页面提供完整的交互式搜索体验，输入即搜，也支持 URL 参数 `/search?q=<关键词>` 书签搜索

搜索评分规则：标题精确匹配 > 标题包含 > 标签匹配 > 描述匹配 > 内容包含

---

## 文章归档

`/archive` 页面按年 → 月分组展示所有文章：

```
2026
├─ 05 (2)
  05-01 文章标题
  04-30 文章标题
```

命令行输入 `archive` 或导航栏点击 archive 即可访问。

---

## 分页

`/blog` 每页显示 5 篇文章，底部显示页码导航：`← prev 1 2 … next →`。超过 5 篇自动分页。

---

## 格言彩蛋

首页底部有一个 `$ fortune` 框，随机显示一句编程格言。在命令面板输入 `fortune` 也会弹出一句随机格言。格言数据包含中英文，部分出自知名程序员。

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

## 博客统计与热力图

`/activity` 页面集成了博客统计和可视化面板：

- **$ stats** — 总文章数、总字符数、标签数、时间跨度、月均发布量
- **ASCII 热力图** — 当年每日发布频率（颜色深浅表示文章数量），点击格子直达当日文章
- **标签分布柱状图** — 按频率排序的 ASCII 柱状图，直观展示标签热度

命令行输入 `activity` 或 `stats` 均可访问。

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
