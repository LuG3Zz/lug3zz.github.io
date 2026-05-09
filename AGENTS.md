# brownlu-blog — AGENTS.md

## Commands
- `npm run dev` — dev server at `localhost:4321`
- `npm run build` — `astro build` (typecheck removed — 104 strict TS errors not applicable)
- `npm run preview` — preview production build

## Architecture
- **Astro 5** static site, terminal-themed, language zh-CN, base font-size 16px
- Pure CSS theming via custom properties (8 themes: terminal, catppuccin, matrix, nord, gruvbox, dracula, tokyo-night, one-dark), with smooth 0.3s transition on theme switch
- CRT scanline overlay via `body::after` with repeating-linear-gradient
- Terminal window chrome: `.window-titlebar` with three colored dots (red/yellow/green) + `.win-title`
- z-index managed via CSS variables: `--z-sidebar`/`--z-island`/`--z-toast`/`--z-backtop`/`--z-matrix`
- All client JS in `<script is:inline>` blocks (no module processing, avoids esbuild `await` errors on Chinese path)
- JS split into 5 components in `src/components/scripts/`:
  - `CoreScripts.astro` — toast, weather, crypto, Gist sync, todo/display/utils, **profile rendering** (`renderAuthorInfo`/`renderUserProfile`/`imageToAscii`/`typeBio`), sidebar panel toggle/resizer/alignment, theme-adaptive avatar filter
  - `MusicPlayer.astro` — music search/play/next/prev/stop, Dynamic Island widget + spectrum
  - `CommandDefs.astro` — 35+ command dispatch map (navigation, todo, habit, mood, post, music, **profile**, etc.)
  - `TabCompletion.astro` — tab completion, inline grep search, keyboard events, pomodoro timer
  - `InitScripts.astro` — article page setup (TOC/scroll-spy/copy/password/progress), startup restore, theme switcher, SPA navigation, pomodoro timer, typewriter effect for now page posts
- Data persisted via GitHub Gist API (public Gist) + localStorage fallback, encrypted with XOR + SHA-256
- SPA navigation: internal link clicks intercepted, `<main>` replaced via fetch — audio/state survives page transitions
- Tab completion data (slugs/tags/series/scripts) + theme names embedded as JSON at build time
- Theme selector on command line row + `theme` command (tab completion for theme names)
- Zen mode (`zen` command / localStorage `zen` key)
- Weather widget on homepage via `wttr.in` API (geolocation + manual `weather <city>` command)
- Music player via `music-api.gdstudio.xyz` (search/play/next/prev/stop/list) + floating Dynamic Island with animated spectrum
- **Sidebar panels**: left `#info-left` for todo/habit/mood/post display, right `#info-right` for profile (author info when logged out, user profile when logged in). Both `position: fixed` with slide-in animation via `transform: translateX`. Vertical alignment dynamically set to nav bottom. Expand/collapse via `[<]`/`[>]` buttons and `togglePanel()`/`expandPanel()` functions.
- **Profile system**: `profile avatar <url>` converts image to ASCII via Canvas, `profile bio <text>` sets welcome message (synced to Gist when logged in). Author avatar displayed directly as `<img>` with CSS filter `grayscale(100%) sepia(100%) hue-rotate()` adapting to current theme's `--green` color.
- **Typewriter effects**: `/now` page posts type out character by character. Bio text in profile sidebar types out with smooth scrolling (`typeBio()` function).
- Fortune quotes, back-to-top, post pinning, cover images, reading progress bar
- Remark plugins for Obsidian syntax (`[[wikilink]]`, `![[image]]`, `> [!callout]`)

## Pages (all in `src/pages/`)
| Route | File | Description |
|-------|------|-------------|
| `/` | `index.astro` | Home with welcome, cowsay, help (2-column grid), latest 5 posts, fortune |
| `/blog` | `blog/index.astro` | Post listing (paginated, 5/page) |
| `/blog/[slug]` | `blog/[slug].astro` | Post detail with TOC sidebar (>1200px), mobile collapsible TOC, scroll-spy, reading progress bar, copy button on code blocks, `.md` download link, cover image banner, **article title + description** |
| `/blog/page/[page]` | `blog/page/[page].astro` | Paginated blog listing (pages 2+) |
| `/tags` | `tags/index.astro` | Tag **word cloud** with size/color/opacity by frequency |
| `/tags/[tag]` | `tags/[tag].astro` | Posts filtered by tag |
| `/activity` | `activity.astro` | Blog stats in 3-column grid + year heatmap + **tag word cloud + pie** + weekday bars **with distinct colors** + cumulative line chart |
| `/archive` | `archive.astro` | Posts grouped by year → month (anchored for year links) |
| `/travel` | `travel.astro` | Leaflet map with markers from `src/data/travel.js` |
| `/scripts` | `scripts.astro` | Lists files from `public/scripts/` |
| `/downloads` | `downloads.astro` | Lists files from `public/downloads/` |
| `/dashboard` | `dashboard.astro` | Personal dashboard with stats overview |
| `/now` | `now.astro` | Timeline page with **typewriter effect** on posts |
| `/about` | `about.astro` | About page with fastfetch-style system info |
| `/series` | `series/index.astro` | Series list from content collection |
| `/series/[series]` | `series/[series].astro` | Posts filtered by series |
| `/search` | `search.astro` | Full-text search (build-time index, client-side) |
| `/404` | `404.astro` | Custom 404 page |

## Content Collections
- Blog posts in `src/content/blog/` as `.md` files with frontmatter
- Schema: `title`, `date` (Date), `description?`, `tags?` (string[]), `slug?`
- `series` and `seriesOrder` for organizing posts into series
- `pinned` optional boolean for pinning posts to top of listings
- `image` optional string for cover image path
- `password` optional string for password-protected articles (hidden from listings)
- `draft` optional boolean — set `true` to exclude from build (not published)
- Template at `src/content/blog/_template.md` with all fields documented
- Dynamic listing via `getCollection("blog")` — new `.md` file auto-appears
- Articles published within 7 days show `[NEW]` badge (green with pulse animation)

## Deployment
- GitHub Pages via `.github/workflows/deploy.yml` (triggers on push to `main`)
- Site URL: `https://lug3zz.github.io`
- Build output in `dist/`
- Local: `git push origin HEAD:main` (repo default branch is `master`)

## Public Assets
- `public/scripts/` — shell scripts served at `/scripts/`
- `public/downloads/` — downloadable files served at `/downloads/`
- `public/images/` — cover images, avatar, etc.

## Data
- `src/data/travel.js` — travel places array
- `src/data/quotes.js` — fortune quotes for homepage + command

## Styling
- Pure CSS in `src/styles/terminal.css`
- CSS custom properties for theming in `:root` + theme-specific `[data-theme="..."]`
- `.section-box` / `.sec-head` — reusable terminal-style section containers with border and mono font
- `.expand-btn` — fixed position expand buttons for sidebar panels
- `.window-titlebar` — terminal window chrome with three colored dots
- Theme transitions, CRT scanline, z-index variables all managed in `terminal.css`
