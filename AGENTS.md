# brownlu-blog — AGENTS.md

## Commands
- `npm run dev` — dev server at `localhost:4321`
- `npm run build` — `astro check && astro build` (typecheck + build)
- `npm run preview` — preview production build

## Architecture
- **Astro 5** static site, terminal-themed, language zh-CN
- Pure CSS theming via custom properties (5 themes: terminal, catppuccin, matrix, nord, gruvbox)
- Client-side command palette in Layout.astro (Tab completion with argument support for `cat`/`tag`/`series`/`get`/`cd`; cycling via `tabIsCmd` flag)
- Tab completion data (slugs/tags/series/scripts) embedded as JSON at build time for client-side autocomplete
- Theme selector on command line row
- Zen mode (`zen` command / localStorage `zen` key) hides header/footer/nav for distraction-free reading
- Weather widget on homepage via `wttr.in` API (geolocation + manual `weather <city>` command, localStorage)
- Typewriter effect + cowsay on homepage welcome message
- Fortune quotes (random quote on homepage + `fortune` command)
- Back-to-top button (appears on scroll >300px)
- Post pinning (`pinned: true` in frontmatter sorts to top)
- Cover images (`image` field in frontmatter, banner with transparency gradient on detail page, thumbnails in listings)
- Inline grep search (results panel below command input, no page navigation)
- Remark plugins for Obsidian syntax (`[[wikilink]]`, `![[image]]`, `> [!callout]`)
- No test/lint/formatter config

## Pages (all in `src/pages/`)
| Route | File | Description |
|-------|------|-------------|
| `/` | `index.astro` | Home with welcome, cowsay, help, latest 5 posts |
| `/blog` | `blog/index.astro` | Post listing (paginated, 5/page) |
| `/blog/[slug]` | `blog/[slug].astro` | Post detail with TOC sidebar (>1200px), mobile collapsible TOC, scroll-spy, reading progress bar, copy button on code blocks, `.md` download link, reading time above content, cover image banner with fade |
| `/blog/page/[page]` | `blog/page/[page].astro` | Paginated blog listing (pages 2+) |
| `/tags` | `tags/index.astro` | Tag list with post counts |
| `/tags/[tag]` | `tags/[tag].astro` | Posts filtered by tag |
| `/activity` | `activity.astro` | Blog stats + year heatmap (GitHub-style squares) + tag bar chart + tag pie + weekday radar + cumulative line chart |
| `/archive` | `archive.astro` | Posts grouped by year → month (anchored for year links) |
| `/travel` | `travel.astro` | Leaflet map with markers from `src/data/travel.js` |
| `/scripts` | `scripts.astro` | Lists files from `public/scripts/` |
| `/downloads` | `downloads.astro` | Lists files from `public/downloads/` |
| `/about` | `about.astro` | About page with fastfetch-style system info |
| `/series` | `series/index.astro` | Series list from content collection |
| `/series/[series]` | `series/[series].astro` | Posts filtered by series |
| `/search` | `search.astro` | Full-text search (build-time index, client-side) |
| `/404` | `404.astro` | Custom 404 page |

## Content Collections
- Blog posts in `src/content/blog/` as `.md` files with frontmatter
- Schema defined in `src/content/config.ts`: `title`, `date` (Date), `description?`, `tags?` (string[]), `slug?`
- `slug` field in frontmatter overrides default slug — always set it explicitly
- `series` and `seriesOrder` optional fields for organizing posts into series
- `pinned` optional boolean for pinning posts to top of listings
- `image` optional string for cover image path
- `password` optional string for password-protecting articles (hidden from listings, unlocked via password form)
- Dynamic listing via `getCollection("blog")` — new `.md` file auto-appears
- Dynamic route `src/pages/blog/[slug].astro` renders each post with Layout.astro

## Deployment
- GitHub Pages via `.github/workflows/deploy.yml` (triggers on push to `main`)
- Site URL: `https://lug3zz.github.io`
- Build output in `dist/`
- **IMPORTANT**: repo default branch on GitHub is `master`, not `main`. After pushing to `main`, the workflow runs but Pages may still serve old `master` content. To deploy, either: (a) rename `main` to `master` and force-push, or (b) change GitHub repo default branch to `main`.

## Public Assets
- `public/scripts/` — shell scripts served at `/scripts/`
- `public/downloads/` — downloadable files served at `/downloads/`
- `public/images/` — Leaflet marker icons for travel map, cover images, etc.

## Data
- `src/data/travel.js` — travel places array with lat/lng/city/date/description/images
- `src/data/quotes.js` — fortune quotes for homepage + command

## Styling
- Pure CSS in `src/styles/terminal.css`
- CSS custom properties for theming in `:root` + theme-specific `[data-theme="..."]`
