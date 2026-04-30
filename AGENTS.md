# terminal-blog — AGENTS.md

## Commands
- `npm run dev` — dev server at `localhost:4321`
- `npm run build` — `astro check && astro build` (typecheck + build)
- `npm run preview` — preview production build

## Architecture
- **Astro 5** static site, terminal-themed, language zh-CN
- No test/lint/formatter config
- Deploys to GitHub Pages on push to `main` via `.github/workflows/deploy.yml`
- Site URL: `https://lug3zz.github.io`

## Content Collections
- Blog posts in `src/content/blog/` as `.md` files
- Schema defined in `src/content/config.ts` (title, date, description, tags)
- Dynamic listing via `getCollection("blog")` — no hardcoded links
- Dynamic route `src/pages/blog/[slug].astro` renders each post with Layout
- New post = add `.md` file to `src/content/blog/`, it appears automatically
- Add a dummy post or do a build to verify dynamic routes work

## Styling
- Pure CSS terminal theme in `src/styles/terminal.css`
- CSS custom properties for theming in `:root`
