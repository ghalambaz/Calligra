import { defineCollection, z } from 'astro:content';

const blogCollection = defineCollection({
    schema: z.object({
      title: z.string(),
      description: z.string(),
      datetime: z.string(),
      image: z.string().optional(),
      category: z.string().default('General'),
      tags: z.array(z.string()).default([]),
    }),
});

export const collections = {
  'blog': blogCollection,
};
