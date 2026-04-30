---
name: wiki-help
description: Show help for all wiki skills, list available vaults, and explain how to use the LLM Wiki. Use when the user asks for help, doesn't know what commands are available, or needs guidance on wiki workflows.
user-invocable: true
allowed-tools: Read Bash(ls *) Glob
---

# Wiki Help

Show available vaults, then print the help text below.

## Steps

1. List top-level directories in the repo that contain a `wiki/` subfolder — those are the available vaults.
2. For each vault, also note whether it has a `CLAUDE.md` (vault-specific guidance) and how many wiki pages it contains (`ls <vault>/wiki | wc -l`).
3. Print a short "Available vaults" section at the top, then the rest of the help text below it.

---

## LLM Wiki — Multi-vault knowledge base

The repo can hold multiple **vaults**. Each vault is a top-level folder with its own `raw/`, `wiki/`, and (optional) `CLAUDE.md`. Skills always operate inside a single vault.

### Commands

| Command | Description |
|---------|-------------|
| `/ingest [vault] [path]` | Process a source document into a vault. Creates a summary page, entity/concept pages, cross-references, and updates the vault's index and log. |
| `/query [vault] <question>` | Ask a question against a vault. Searches pages, synthesizes an answer with citations, and offers to save substantial answers. |
| `/save [vault] <title>` | Save the last query answer or analysis as a permanent wiki page in a vault. |
| `/lint [vault]` | Semantic health-check (contradictions, orphans, missing links, stale content, gaps). |
| `/audit [vault] [--fix]` | Mechanical schema-compliance check (frontmatter, filenames, wikilink resolution, index coverage, log format). Pass `--fix` to auto-resolve mechanical issues. |
| `/wiki-help` | Show this help message. |
| `/ufo-news [topic]` | **`ufo` vault only.** Search the web for the latest UFO/UAP/alien news, save to `ufo/raw/inbox/`, and ingest into `ufo/wiki/`. Optional topic narrows the search. |

If exactly one vault exists, the `[vault]` argument is optional and the skill defaults to it. Otherwise the first argument must name a vault.

### Getting Started

1. **Pick a vault** (or create a new one — see "Add a vault" below).
2. **Add a source**: drop an article, paper, or notes file into `<vault>/raw/inbox/`.
3. **Ingest it**: `/ingest <vault> <vault>/raw/inbox/your-file.md` (or just `/ingest <vault>` to drain the whole inbox).
4. **Explore**: open the `<vault>/` folder as an Obsidian vault, browse the new pages, check the graph view.
5. **Ask questions**: `/query <vault> What are the key themes so far?`
6. **Save insights**: `/save <vault> My Analysis Title` to preserve a good answer.
7. **Maintain**: `/lint <vault>` for semantic health, `/audit <vault>` for mechanical compliance.

### Add a vault

To create a new vault `foo/`:

1. Make the folder layout: `foo/raw/inbox/`, `foo/raw/assets/`, `foo/wiki/`.
2. Create empty `foo/wiki/index.md` and `foo/wiki/log.md`.
3. (Optional but recommended) Create `foo/CLAUDE.md` describing the vault's topic, scope, and any vault-specific conventions.
4. Open `foo/` as a separate Obsidian vault if you want graph view.

### Tips

- **Obsidian Web Clipper** converts web articles to markdown — clip straight into `<vault>/raw/inbox/`.
- **Download images locally**: in Obsidian, set attachment folder to `<vault>/raw/assets/`.
- **Graph view** in Obsidian shows the shape of one vault — hubs, orphans, clusters.
- The repo is a **git repo** — you get version history for free.
- Ingest sources one at a time to stay involved and guide emphasis, or batch them for speed.
- Good query answers can be saved as wiki pages — your explorations compound.

### Architecture

```
<repo>/
  CLAUDE.md           → Multi-vault schema and shared conventions
  .claude/skills/     → Slash-command definitions (vault-aware)
  <vault>/
    CLAUDE.md         → Vault-specific guidance (optional)
    raw/              → Source documents (you write, LLM reads)
    raw/inbox/        → Pending sources
    wiki/             → Knowledge pages (LLM writes, you read)
    wiki/index.md     → Page catalog — read first on every query
    wiki/log.md       → Activity timeline
    .obsidian/        → Per-vault Obsidian config
```

Wikilinks never cross vault boundaries — each vault is its own knowledge base.
