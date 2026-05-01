import { defineConfig } from "astro/config";
import mdx from "@astrojs/mdx";
import { wikilinkPlugin, obsidianImagePlugin, calloutPlugin } from "./src/plugins/remark-obsidian.mjs";

export default defineConfig({
  integrations: [mdx()],
  site: "https://lug3zz.github.io",
  markdown: {
    remarkPlugins: [wikilinkPlugin, obsidianImagePlugin, calloutPlugin],
  },
});
