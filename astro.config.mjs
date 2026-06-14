import { defineConfig } from 'astro/config';

import tailwind from '@tailwindcss/vite';
import icon from 'astro-icon';
import mdx from '@astrojs/mdx';
import sitemap from '@astrojs/sitemap';

export default defineConfig({
  site: 'https://calligra.dev',
  base: '/',
  build: {
      emptyOutDir: false,
  },
  // 1. Move Tailwind out of here and keep only your standard Astro integrations
  integrations: [
    icon(), 
    mdx(), 
    sitemap()
  ],
  // 2. Pass Tailwind directly to the Vite compilation layer
  vite: {
    plugins: [
      tailwind({
        config: './tailwind.config.mjs'
      })
    ]
  }
});