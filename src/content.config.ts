import { defineCollection, z } from 'astro:content';
// 1. Import the glob loader from the new location
import { glob } from 'astro/loaders'; 

const blogCollection = defineCollection({
    // 2. Point the loader to your markdown/mdx files inside src/content/blog
    loader: glob({ pattern: '**/[^_]*.{md,mdx}', base: "./src/content/blog" }),
    schema: z.object({
      title: z.string(),
      description: z.string(),
      datetime: z.string(),
      image: z.string().optional(),
      type: z.string().default('Article'),
      time_to_read: z.number().default(5),
      level: z.string().default('Beginner'),
      category: z.string().default('General'),
      tags: z.array(z.string()).default([]),
    }),
});

export const collections = {
  'blog': blogCollection,
};