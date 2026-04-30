# LLM Wiki

A multi-vault personal knowledge base where **you curate sources** and **Claude does the writing**. Each vault is a topic-scoped folder with its own `raw/` and `wiki/`. Drop articles, papers, and transcripts into a vault's `raw/inbox/`; Claude reads them and builds a densely cross-linked wiki of people, organizations, concepts, and events. Ask questions later and Claude answers from what it built.

Open each vault folder in [Obsidian](https://obsidian.md) to browse its graph.

## Quick start

```bash
# 1. Open the repo as a Claude Code project. Open <vault>/ in Obsidian.
# 2. Add a source (the `ufo` vault is the seed example)
cp ~/Downloads/some-article.md ufo/raw/inbox/

# 3. Ingest it — inside Claude Code
/ingest ufo

# 4. Ask questions
/query ufo What does the wiki say about AARO's case resolution rate?

# 5. Pull in fresh web coverage (UFO vault only)
/ufo-news congressional hearings
```

If only one vault exists, you can omit the vault name from `/ingest`, `/query`, `/save`, and `/lint`.

## How it works

| You do | Claude does |
|--------|-------------|
| Drop a source in `<vault>/raw/inbox/` | Ingest it — summarize, extract entities/concepts, wire up `[[wikilinks]]`, update the vault's index and log |
| Ask `/query <vault> ...` questions | Read relevant wiki pages in that vault, answer with citations, flag gaps and contradictions |
| Ask `/ufo-news` for the latest | Fan out parallel web searches, dedupe, show you candidates, fetch + ingest the ones you pick (always into `ufo/`) |
| Run `/lint <vault>` periodically | Find orphan pages, contradictions, missing cross-references, stale claims |

## Commands

| Command | Scope | What it does |
|---------|-------|--------------|
| `/ingest [vault] [path]` | any vault | Process a source document. Path optional — omit to drain `<vault>/raw/inbox/`. |
| `/query [vault] <question>` | any vault | Answer a question from the vault with citations. |
| `/save [vault] <title>` | any vault | Save the last query answer as a permanent wiki page. |
| `/lint [vault]` | any vault | Semantic health-check (contradictions, orphans, gaps). |
| `/audit [vault] [--fix]` | any vault | Mechanical compliance check against the schema in `CLAUDE.md`. Pass `--fix` to auto-resolve fixable issues. |
| `/new-vault <name> ["topic"]` | repo-wide | Scaffold a new vault folder with seed `CLAUDE.md`, `index.md`, and `log.md`. |
| `/wiki-help` | repo-wide | Show help and list vaults. |
| `/ufo-news [topic]` | `ufo/` only | Search the web for recent UFO/UAP/alien news, save to `ufo/raw/inbox/`, ingest. Topic is optional and narrows the search (e.g. `aaro`, `grusch`, `congressional hearings`). Uses parallel agent teams. |

## Project structure

```
<repo>/
  CLAUDE.md           Multi-vault schema and shared conventions
  .claude/skills/     Slash-command definitions (vault-aware)
  <vault>/            One folder per vault — currently: `ufo/`
    CLAUDE.md         Optional vault-specific guidance (topic, scope)
    raw/inbox/        Sources waiting to be ingested (you drop files here)
    raw/              Sources that have been ingested (immutable after ingest)
    raw/assets/       Downloaded images and attachments
    wiki/             The wiki itself — markdown pages Claude writes
    wiki/index.md     Catalog of every page, organized by category
    wiki/log.md       Chronological activity log
    .obsidian/        Per-vault Obsidian config (each vault is its own Obsidian vault)
```

Every wiki page has YAML frontmatter (`title`, `type`, `created`, `updated`) and uses `[[wikilinks]]` everywhere. Source pages additionally link back to the raw file they came from. **Wikilinks never cross vault boundaries** — each vault is its own knowledge base.

Page types: **source** (one article/paper/transcript), **entity** (a person, org, program, aircraft), **concept** (an idea, method, framework), **analysis** / **comparison** (synthesis across sources — usually produced by `/save`).

## Adding a vault

The fastest way:

```
/new-vault security "Security research notes, vulnerability advisories, and red-team tradecraft."
```

That scaffolds the folder layout (`raw/inbox/`, `raw/assets/`, `wiki/`), seeds `CLAUDE.md` with the topic and scope you describe, and creates an empty `index.md` and a `log.md` with an init entry. Skills auto-discover vaults by scanning top-level dirs that contain a `wiki/` subfolder, so the new vault is immediately usable by `/ingest`, `/query`, `/save`, `/lint`, and `/audit`.

If you'd rather do it manually:

1. `mkdir -p foo/raw/inbox foo/raw/assets foo/wiki`
2. `touch foo/wiki/index.md foo/wiki/log.md`
3. (Recommended) create `foo/CLAUDE.md` describing the topic, scope, and any vault-specific conventions.
4. Optional: open `foo/` as a separate Obsidian vault.

## How `/ufo-news` works under the hood

The `/ufo-news` command runs a multi-phase parallel workflow, scoped to the `ufo/` vault:

1. **Search** — fans out one `Agent` per track (hearings, AARO, whistleblowers, primary sources, astrobiology, etc.) in a single message. They return candidate URLs in parallel.
2. **Triage** — the main agent dedupes against what's already in `ufo/raw/` and `ufo/wiki/`, shows you a numbered table, asks which to ingest.
3. **Fetch** — one parallel agent per chosen URL; each writes its own file to `ufo/raw/inbox/`.
4. **Analyze** — one parallel agent per saved file, read-only, returns structured drafts (source page, entity deltas, concept deltas, new index entries).
5. **Merge** — main agent serially writes shared files so there are no conflicts.
6. **Report** — summary of what was ingested, plus cross-connections between the new sources.

Result: a sweep that would take Claude ~20 minutes serially finishes in a few, and you get a densely linked batch instead of N disconnected pages.

## Typical workflows

**Following a beat** — every Monday morning run `/ufo-news` with no topic. Pick the 3-5 stories that actually matter. Let Claude ingest them. Browse the updated entity pages in Obsidian.

**Deep-diving a topic** — run `/query <vault>` on something broad. If the answer is interesting, `/save <vault>` it as an analysis page — it becomes permanent and shows up in future queries.

**Reading a new paper** — drop the PDF in `<vault>/raw/inbox/`, run `/ingest <vault>`. The next time you `/query` anything related, Claude will pull it in.

**Wiki hygiene** — after a few ingests, run `/lint <vault>`. Claude will surface orphan pages, missing cross-references, and contradictions between sources.

## Tips

- **Obsidian Web Clipper** converts web pages to markdown — clip straight into `<vault>/raw/inbox/`.
- **Graph view** in Obsidian shows hubs, clusters, and orphans — it's the best way to see the shape of one vault.
- The repo is a **git repo** — you get version history for free. Commit after each ingest if you want a clean timeline.
- **Ingest sources one at a time** if you want to stay in the loop and guide emphasis. Batch them (or use `/ufo-news`) when you just want coverage.
- Good `/query` answers are worth saving — exploration compounds.
