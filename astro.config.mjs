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
  integrations: [
    icon(), 
    mdx(), 
    sitemap()
  ],
  vite: {
    plugins: [
      tailwind({
        config: './tailwind.config.mjs'
      })
    ]
  }
});