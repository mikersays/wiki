# LLM Wiki

A personal knowledge base where **you curate sources** and **Claude does the writing**. Drop articles, papers, and transcripts into `raw/`; Claude reads them and builds a densely cross-linked wiki of people, organizations, concepts, and events. Ask questions later and Claude answers from what it built.

Open the whole thing in [Obsidian](https://obsidian.md) to browse the graph.

## Quick start

```bash
# 1. Open this folder as a Claude Code project (and as an Obsidian vault)
# 2. Add a source
cp ~/Downloads/some-article.md raw/inbox/

# 3. Ingest it — inside Claude Code
/ingest

# 4. Ask questions
/query What does the wiki say about AARO's case resolution rate?

# 5. Pull in fresh web coverage on a beat you follow
/ufo-news congressional hearings
```

## How it works

| You do | Claude does |
|--------|-------------|
| Drop a source in `raw/inbox/` | Ingest it — summarize, extract entities/concepts, wire up `[[wikilinks]]`, update the index and log |
| Ask `/query` questions | Read relevant wiki pages, answer with citations, flag gaps and contradictions |
| Ask `/ufo-news` for the latest | Fan out parallel web searches, dedupe, show you candidates, fetch + ingest the ones you pick |
| Run `/lint` periodically | Find orphan pages, contradictions, missing cross-references, stale claims |

## Commands

| Command | What it does |
|---------|--------------|
| `/ingest [path]` | Process a source document. Path optional — omit to drain `raw/inbox/`. |
| `/ufo-news [topic]` | Search the web for recent UFO/UAP/alien news, save to `raw/inbox/`, ingest. Topic is optional and narrows the search (e.g. `aaro`, `grusch`, `congressional hearings`). Uses parallel agent teams. |
| `/query <question>` | Answer a question from the wiki with citations. |
| `/save <title>` | Save the last query answer as a permanent wiki page. |
| `/lint` | Health-check the whole wiki. |
| `/wiki-help` | Show help inside Claude Code. |

## Project structure

```
raw/inbox/      Sources waiting to be ingested (you drop files here)
raw/            Sources that have been ingested (immutable after ingest)
raw/assets/     Downloaded images and attachments
wiki/           The wiki itself — markdown pages Claude writes
wiki/index.md   Catalog of every page, organized by category
wiki/log.md     Chronological activity log
CLAUDE.md       Schema and conventions Claude follows
.claude/skills/ Slash-command definitions
```

Every wiki page has YAML frontmatter (`title`, `type`, `created`, `updated`) and uses `[[wikilinks]]` everywhere. Source pages additionally link back to the raw file they came from.

Page types: **source** (one article/paper/transcript), **entity** (a person, org, program, aircraft), **concept** (an idea, method, framework), **analysis** / **comparison** (synthesis across sources — usually produced by `/save`).

## How `/ufo-news` works under the hood

The `/ufo-news` command runs a multi-phase parallel workflow:

1. **Search** — fans out one `Agent` per track (hearings, AARO, whistleblowers, primary sources, astrobiology, etc.) in a single message. They return candidate URLs in parallel.
2. **Triage** — the main agent dedupes against what's already in `raw/` and `wiki/`, shows you a numbered table, asks which to ingest.
3. **Fetch** — one parallel agent per chosen URL; each writes its own file to `raw/inbox/`.
4. **Analyze** — one parallel agent per saved file, read-only, returns structured drafts (source page, entity deltas, concept deltas, new index entries).
5. **Merge** — main agent serially writes shared files so there are no conflicts.
6. **Report** — summary of what was ingested, plus cross-connections between the new sources.

Result: a sweep that would take Claude ~20 minutes serially finishes in a few, and you get a densely linked batch instead of N disconnected pages.

## Typical workflows

**Following a beat** — every Monday morning run `/ufo-news` with no topic. Pick the 3-5 stories that actually matter. Let Claude ingest them. Browse the updated entity pages in Obsidian.

**Deep-diving a topic** — run `/query` on something broad. If the answer is interesting, `/save` it as an analysis page — it becomes permanent and shows up in future queries.

**Reading a new paper** — drop the PDF in `raw/inbox/`, run `/ingest`. The next time you `/query` anything related, Claude will pull it in.

**Wiki hygiene** — after a few ingests, run `/lint`. Claude will surface orphan pages, missing cross-references, and contradictions between sources.

## Tips

- **Obsidian Web Clipper** converts web pages to markdown — clip straight into `raw/inbox/`.
- **Graph view** in Obsidian shows hubs, clusters, and orphans — it's the best way to see the shape of your wiki.
- The wiki is a **git repo** — you get version history for free. Commit after each ingest if you want a clean timeline.
- **Ingest sources one at a time** if you want to stay in the loop and guide emphasis. Batch them (or use `/ufo-news`) when you just want coverage.
- Good `/query` answers are worth saving — exploration compounds.
