import { defineCollection, z } from "astro:content";

const blog = defineCollection({
  type: "content",
  schema: z.object({
    title: z.string(),
    date: z.date(),
    description: z.string().optional(),
    tags: z.array(z.string()).optional(),
    slug: z.string().optional(),
  }),
  slug: ({ data, defaultSlug }) => data.slug || defaultSlug,
});

export const collections = { blog };
