# terminal-blog — AGENTS.md

## Commands
- `npm run dev` — dev server
- `npm run build` — `astro check && astro build` (typecheck + build; `astro check` is the type checker, not a separate tool)
- `npm run preview` — preview production build
- `npx astro add <integration>` — add new Astro integrations

## Architecture
- **Astro 5** static site, terminal-themed, primary language is zh-CN
- No test/lint/formatter config — project is minimal
- Site deploys to GitHub Pages on push to `main` via `.github/workflows/deploy.yml`
- Site URL: `https://lug3zz.github.io` (lowercase)

## Content
- Blog posts live in `src/pages/blog/` as `.md` files with frontmatter
- Frontmatter must include `layout: ../../layouts/Layout.astro` for the terminal theme
- `src/content/` and `src/components/` are empty — ready for future use
- `src/types.ts` defines a `Post` interface but is not yet wired into any page (blog listing is hardcoded)

## Styling
- Pure CSS terminal theme in `src/styles/terminal.css` — no CSS framework
- CSS custom properties for theming in `:root`
