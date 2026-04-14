---
name: wiki-help
description: Show help for all wiki skills and how to use the LLM Wiki. Use when the user asks for help, doesn't know what commands are available, or needs guidance on wiki workflows.
user-invocable: true
allowed-tools: Read
---

# Wiki Help

Display the following help text to the user. Do not modify it — print it as-is.

---

## LLM Wiki — Commands

| Command | Description |
|---------|-------------|
| `/ingest <path>` | Process a source document into the wiki. Creates a summary page, entity/concept pages, cross-references, and updates the index and log. |
| `/query <question>` | Ask a question against the wiki. Searches pages, synthesizes an answer with citations, and offers to save substantial answers. |
| `/save <title>` | Save the last query answer or analysis as a permanent wiki page. |
| `/lint` | Health-check the wiki. Finds contradictions, orphan pages, missing links, stale content, and gaps. |
| `/wiki-help` | Show this help message. |

## Getting Started

1. **Add a source**: Drop an article, paper, or notes file into `raw/`.
2. **Ingest it**: Run `/ingest raw/your-file.md`.
3. **Explore**: Open Obsidian, browse the new pages, check the graph view.
4. **Ask questions**: Run `/query What are the key themes so far?`
5. **Save insights**: Run `/save My Analysis Title` to preserve a good answer.
6. **Maintain**: Run `/lint` periodically to keep the wiki healthy.

## Tips

- **Obsidian Web Clipper** converts web articles to markdown — clip straight into `raw/`.
- **Download images locally**: In Obsidian, set attachment folder to `raw/assets/` and bind the download hotkey.
- **Graph view** in Obsidian shows the shape of your wiki — hubs, orphans, clusters.
- The wiki is a **git repo** — you get version history for free.
- Ingest sources one at a time to stay involved and guide emphasis, or batch them for speed.
- Good query answers can be saved as wiki pages — your explorations compound.

## Architecture

```
raw/            → Source documents (you write, LLM reads)
wiki/           → Knowledge pages (LLM writes, you read)
wiki/index.md   → Page catalog — the LLM reads this first on every query
wiki/log.md     → Activity timeline
CLAUDE.md       → Schema and conventions governing the wiki
```
