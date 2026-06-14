# Repository Settings

* **Repository Name:** `calligra-astro-template`
* **Short Description (GitHub Sidebar):** A free Astro template and automation toolkit to write once and seamlessly cross-publish content to multiple platforms. Forked and enhanced from astro-resume-theme. Powers calligra.dev.
* **Topics/Tags:** `astro`, `astro-template`, `portfolio`, `blog`, `cross-posting`, `automation`, `tailwind-css`, `markdown`

---

# README.md

# 🖋️ Calligra Astro Template

A free, open-source static site template and deployment toolkit designed for developers who want to own their content. Built on top of the excellent **Astro Resume Theme**, Calligra includes pre-configured automation scripts and tutorials to help you **write once and publish to multiple destinations** effortlessly.

This repository powers the live production site at [calligra.dev](https://calligra.dev).

---

## 🚀 Features

- **Write Once, Publish Anywhere:** Automation workflows for syncing content from Notion and cross-posting Markdown articles to Medium, Dev.to, and Hashnode.
- **Modern Stack:** Built with [Astro](https://astro.build/) for ultimate speed and styled with [Tailwind CSS](https://tailwindcss.com/) for easy customization.
- **Enhanced Blog Engine:** Extended from the base theme to include native Search, Categories, and Tags, plus a dynamic homepage widget showcasing your latest posts.
- **Performance First:** Lightweight architecture delivering outstanding Lighthouse/PageSpeed scores, fully responsive layouts, and built-in SEO optimization.
- **Dark Mode:** Seamless light/dark mode transition out of the box.

---

## 🛠️ Getting Started

### Prerequisites

This project uses `bun` as its primary package manager, though you can substitute it with `npm`, `pnpm`, or `yarn`.

### Installation

1. **Clone the repository:**
   ```bash
   git clone [https://github.com/ghalambaz/Calligra](https://github.com/ghalambaz/Calligra)
   cd Calligra
   ```
2. **Install dependencies:**
   ```bash
   bun install
   ```
3. **Install dependencies:**
   ```bash
   bun run dev
   ```
Open http://localhost:4321 in your browser to view the site.

## 🧞 Commands

| Make | Action |
| :--- | :--- |
| `make run` | Starts local dev server at `localhost:4321`|
| `make build` | build your production site, put content to the output directory |
| `make sync` | Pull content from Notion and generate Markdown posts |
| `make deploy` | Push your production content to the remote repo (github pages) |

# Content Sync and Crossposting Automation

The project includes a Notion sync command and a set of make targets for crossposting posts to external platforms.

## Command Table

| Command | Description | Required Arguments | Status |
| :--- | :--- | :--- | :--- |
| `make sync` | Pull posts from Notion and write them to `src/content/blog`. | `NOTION_TOKEN`, `NOTION_DATABASE_ID` | Ready |
| `make publish` | Scan all posts; process changed ones. | None | Ready |
| `make publish-one` | Force process a specific post. | `slug` | Ready |
| `make set-meta` | Modify frontmatter for a specific post. | `slug`, `key`, `value` | Ready |
| `make hash-show` | View all tracking hashes and status. | None | Ready |
| `make hash-reset` | Reset cache hash for one specific post. | `slug` | Ready |
| `make hash-reset-all` | Reset cache hashes for all posts. | None | Ready |

## Notes

`make sync` reads `NOTION_TOKEN` and `NOTION_DATABASE_ID` from your environment before generating posts.

`make publish` and the other crossposting targets are available now through the `bin/crosspost` script.

⚖️ License & Acknowledgments

- **Source Code:** The source code of this website is licensed under the [MIT License](LICENSE).
- **Content & Articles:** All written content, articles, and media found under the `src/content/` directory are licensed under the [Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International (CC BY-NC-SA 4.0)](src/content/LICENSE-CONTENT)

## Credits
Calligra is built as an extended variant of the astro-resume-theme created by Wasut Panyawiphat, which is also distributed under the MIT License. I am incredibly grateful for their foundational work.
