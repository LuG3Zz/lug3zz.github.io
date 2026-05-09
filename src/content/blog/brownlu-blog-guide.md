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

### 导航与阅读

| 命令 | 功能 |
|------|------|
| `help` | 显示常用命令提示 |
| `ls` | 跳转到文章列表 `/blog` |
| `cat <slug>` | 阅读文章，如 `cat hello-world` |
| `cd <path>` | 切换目录，如 `cd blog`、`cd tags`、`cd search` |
| `tag <name>` | 按标签浏览，如 `tag astro` |
| `series` | 按系列浏览 |
| `grep <query>` | 全文搜索，结果直接显示在当前页面 |
| `rand` | 随机跳转一篇文章 |
| `get <script>` | 获取脚本，如 `get hello.sh` |

### 系统命令

| 命令 | 功能 |
|------|------|
| `login <username> <password>` | 登录并同步 Gist 云端数据 |
| `logout` | 退出登录 |
| `gist-setup <pat> <gistId> <password>` | 首次配置 Gist 同步 |
| `todo [sub]` | 待办事项管理（见下方） |
| `habit <sub>` | 习惯追踪 |
| `mood <1-5>` | 记录今日心情 |
| `post <text>` | 发布微动态 |
| `pomo <min>` | 启动番茄钟，默认 25 分钟 |
| `dashboard` | 个人仪表盘 |
| `now` | 时间线页面 |
| `profile [sub]` | 个人面板管理（头像/欢迎语） |

### 界面与工具

| 命令 | 功能 |
|------|------|
| `theme <name>` | 切换主题 |
| `zen` | 极简阅读模式 |
| `focus` | 专注模式，隐藏导航和列表 |
| `night` | 夜间模式，降低亮度 |
| `matrix` | 切换 Matrix 数字雨背景 |
| `weather <city>` | 查看/设置天气城市 |
| `fortune` | 随机显示一句编程格言 |
| `uptime` | 显示博客运行时长 |
| `tip` | 随机显示一条终端技巧 |
| `whoami` | 关于页面 `/about` |
| `activity` | 博客统计 + 发布热力图 |
| `archive` | 按年/月归档文章 |
| `travel` | 查看旅行地图 |
| `scripts` | 浏览可用脚本 |
| `downloads` | 浏览可下载资源 |
| `save` | 保存当前页面 |
| `date` | 显示当前时间 |
| `profile [sub]` | 个人面板管理（见下方） |
| `clear` | 刷新页面 |
| `music <keyword>` | 搜索并播放音乐（见下方） |

输入命令时按 **Tab** 可自动补全。支持命令补全和参数补全：
- `c` + Tab → 补全为 `cat` / `cd` / `clear`，连续 Tab 循环选择
- `cat he` + Tab → 补全为 `cat hello-world`
- `tag ` + Tab → 列出所有标签
- `cd ` + Tab → 列出所有可切换目录

补全数据在构建时自动生成，新增文章/标签后自动更新。

---

## Zen 极简模式

输入 `zen` 进入极简模式，隐藏导航栏、天气、帮助信息等非内容元素，仅保留提示符和正文，内容垂直居中，适合专注阅读。再次输入 `zen` 恢复。状态持久化，切换页面不闪烁。

---

## 主题切换

导航栏右侧下拉框支持 8 种终端配色主题：

- **terminal** — 经典绿色终端
- **catppuccin** — Catppuccin Mocha 紫粉
- **matrix** — Matrix 绿
- **nord** — 蓝灰 Nord
- **gruvbox** — 暖橙 Gruvbox
- **dracula** — 紫黑 Dracula
- **tokyo-night** — 蓝黑东京夜
- **one-dark** — Atom 编辑器风格

选择后即时切换，通过 `localStorage` 持久化，刷新页面自动恢复，切换页面无闪烁。切换时颜色平滑过渡（0.3s 动画）。也可通过命令切换：`theme dracula`、`theme catppuccin`。

### 页面窗口化

页面顶部有**终端窗口标题栏**（红/黄/绿三色圆点 + 路径标签），标题栏贯穿整个页面形成完整窗口边框，底部有状态栏显示当前主题名。页面背景有极淡的 **CRT 扫描线** overlay，增强终端质感。

---

## 文章管理

文章存储在 `src/content/blog/` 目录，使用 Content Collections 自动管理。新增文章只需创建 `.md` 文件并添加 frontmatter。项目内包含一个完整的模板文件 `_template.md`，包含所有可用字段和写作提示，推荐直接复制使用：

```bash
cp src/content/blog/_template.md src/content/blog/我的文章.md
```

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
npm run build      # 构建静态网站
npm run preview    # 预览生产构建
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
password: "your-pw"       # 可选，密码保护（不显示在列表）
draft: true               # 可选，草稿（不参与构建发布）
---
```

写作时浏览器打开 `http://localhost:4321` 实时预览。完成后：

```bash
npm run build        # 构建
git add -A
git commit -m "add: 新文章 my-post"
git push origin main # 自动部署到 GitHub Pages
```

> 提示：希望用 AI 协助写作时，可参考 `AGENTS.md` 了解项目结构与约定，让 AI 更快理解系统。

### 使用 Neovim

Neovim 配合本系统的推荐工作流：

1. 打开项目根目录：`nvim .`
2. 新建文章：`src/content/blog/my-post.md`
3. 粘贴 frontmatter 模板并填写
4. 分屏预览：`:terminal npm run dev` 启动开发服务器，浏览器查看
5. 使用 `gf` 命令跳转图片/链接路径进行验证

可选：在 `~/.config/nvim/snippets/` 或 `~/.config/nvim/UltiSnips/` 中添加 markdown 文章模板片段：

```text
snippet frontmatter "Blog post frontmatter"
---
title: "${1:文章标题}"
date: ${2:`date +%Y-%m-%d`}
description: "${3:描述}"
tags: [${4:}]
slug: ${5:my-post}
---
$0
endsnippet
```

### 适配 Obsidian

本系统的 `.md` 文件可直接在 Obsidian 中打开和编辑，将项目目录作为 Obsidian 仓库即可。

系统内置了三个 remark 插件自动转换 Obsidian 语法为标准 markdown：

**`[[wikilink]]` 内部链接**

```markdown
[[astro-intro]]              → <a href="/blog/astro-intro">
[[astro-intro|显示文字]]      → <a href="/blog/astro-intro">显示文字</a>
[[series/Astro 入门]]        → <a href="/series/Astro 入门">
```

**`![[image]]` 图片嵌入**

```markdown
![[cover.jpg]]               → ![](/images/cover.jpg)
![[travel/beach.jpg]]        → ![](/images/travel/beach.jpg)
```

**`> [!type]` 标注块**

```markdown
> [!note] 标题
> 支持 note / tip / warning / danger / info
```

注意事项：

- 避免在文章中使用 `[[about]]` 这样的短链接 — 会被转为 `/blog/about`，如需链接到 `/about` 页面请用 `[/about]`
- 图片自动映射到 `public/images/` 目录，请确保文件存在
- 链接目标为不存在的 slug 时会产生 404，不影响构建

> [!tip]
> 直接用 Obsidian 写文章即可，[[brownlu-blog-guide|本系统]]会自动处理语法转换！

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

- **文章标题 + 描述** — 详情页文章标题以 `<h1>` 显示，frontmatter 中的 `description` 字段自动显示在标题下方
- **SPA 导航** — 点击文章链接无需整页刷新，`<main>` 区域动态替换，音乐播放不中断，命令输入状态保持
- **封面 banner** — 有封面图的文章顶部显示通栏渐隐 banner
- **最新标记** — 发布 7 天内的文章自动显示绿色 `[NEW]` 徽标（带脉冲动画）
- **大纲侧边栏** — 屏幕宽 >1200px 时左侧显示固定目录，滚动时高亮当前章节
- **移动端折叠目录** — 手机等窄屏设备上，正文前会出现一个 `[+] Index` 折叠面板，点击展开/收起目录，点击链接后自动收起
- **阅读进度条** — 页面底部居中显示 `📖 ████░░░░░░ 40%` 进度
- **代码块复制** — hover 代码块右上角出现 `copy` 按钮，一键复制
- **下载原文** — 文章底部 `↓ download .md` 下载原始 markdown 文件
- **返回顶部** — 右下角 `^` 按钮，滚动后出现，点击平滑回到顶部

---

## 个人面板

登录后或未登录状态下，右侧栏显示个人/作者信息面板。

### 命令

```bash
profile                          # 切换右侧面板显示/隐藏
profile avatar /images/xxx.jpg   # 设置头像（将图片转换为 ASCII 或直接显示原图）
profile bio <欢迎语>              # 设置自定义欢迎语
```

### 功能

- **未登录**：显示博客作者信息（头像 + 简介 + GitHub 链接）
- **已登录**：显示用户资料（头像、用户名、登录状态、运行时间、日期、待办/习惯/番茄统计）
- **欢迎语**：`profile bio` 设置后存储在 localStorage 或 Gist 云存储（登录后自动同步）
- **头像滤镜**：头像图片自动应用主题匹配的色调滤镜（灰度→棕褐→色相旋转→高饱和）
- **打字机效果**：欢迎语逐字打出，滚动保持可见

### 数据同步

`profile bio` 设置的欢迎语在登录状态下同步到 Gist，换设备登录同一账号自动恢复。

---

## 标签系统

每篇文章可添加标签。`/tags` 页面以**词云**形式展示所有标签：字号/颜色/透明度按使用频率缩放，高频标签更大更亮。鼠标悬停边框高亮，点击跳转至 `/tags/<name>` 查看该标签下的所有文章。

---

## 博客统计与热力图

`/activity` 页面集成了博客统计和可视化面板：

- **$ stats** — 三栏网格（General / Content / Code & Media）展示总文章数、字符数、标签数、时间跨度等
- **$ tables** — 年份分布（带进度条）、星期分布（**每星期不同颜色** Mon~Thu 绿/Fri 黄/Sat 青/Sun 红）、内容统计
- **ASCII 热力图** — 当年每日发布频率，点击格子直达当日文章
- **标签词云 + 饼图** — 左侧词云频率展示，右侧 SVG 饼图比例分布
- **雷达图 + 折线图** — 星期活跃度雷达 + 累计发布折线

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

# 构建
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
