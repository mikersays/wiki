# LLM Wiki Schema

This is a personal knowledge base maintained by an LLM. The human curates sources and directs exploration. The LLM does all the writing, cross-referencing, and maintenance.

## Directory structure

```
raw/inbox/      # New source documents waiting to be ingested
raw/            # Ingested source documents (immutable after ingest)
raw/assets/     # Downloaded images and attachments
wiki/           # LLM-generated markdown pages (the wiki itself)
wiki/index.md   # Content catalog — every page listed with summary and category
wiki/log.md     # Chronological activity log
CLAUDE.md       # This file — schema and conventions
```

## Page conventions

- All wiki pages live in `wiki/`.
- Use `[[wikilinks]]` for cross-references between pages (Obsidian-style).
- Every page gets YAML frontmatter with at least: `title`, `type` (source, entity, concept, analysis, comparison), `created`, `updated`.
- Source pages additionally get: `source_file` (path to raw document), `author`, `date` (of the original source) when available.
- Keep pages focused. One entity, concept, or source per page. Split rather than merge.
- Use descriptive filenames in kebab-case.
- **Naming rules by page type:**
  - **Source pages:** `src-[topic]-[yyyy].md` or `src-[topic]-[yyyy-mm].md` if month is needed to disambiguate. Topic is a brief descriptive slug. Never include outlet/publisher names or spelled-out month names in filenames. Examples: `src-attention-is-all-you-need-2017.md`, `src-uap-whistleblower-hearing-2025.md`.
  - **Entity pages:** `[entity-name].md` — the entity's name in kebab-case. Examples: `david-grusch.md`, `nasa.md`.
  - **Concept pages:** `[concept-name].md` — the concept in kebab-case. Examples: `reinforcement-learning.md`, `biosignatures.md`.
  - **Analysis/comparison pages:** `[descriptive-title].md`. Examples: `uap-disclosure-timeline.md`.

## Workflows

### Ingest

New sources go in `raw/inbox/`. When the user asks to ingest (or specifies a file path directly):

1. If no path is given, scan `raw/inbox/` for files to ingest.
2. Read the source document fully.
3. Discuss key takeaways with the user if they want interaction, or proceed if they say to just process it.
4. Create a source summary page in `wiki/` with frontmatter, summary, key claims, and relevant quotes.
5. Update or create entity pages for important people, organizations, tools, etc. mentioned in the source.
6. Update or create concept pages for key ideas, methods, frameworks.
7. Add `[[wikilinks]]` in all new and updated pages to connect them to existing pages.
8. Update `wiki/index.md` with entries for all new pages.
9. Append an entry to `wiki/log.md`.
10. Move the source file from `raw/inbox/` to `raw/` to mark it as ingested.
11. Report what was created and updated.

A single source typically touches 5-15 wiki pages.

### Query

When the user asks a question:

1. Read `wiki/index.md` to identify relevant pages.
2. Read the relevant pages.
3. Synthesize an answer with `[[wikilinks]]` citations to wiki pages.
4. If the answer is substantial and worth preserving, offer to save it as a new wiki page (type: analysis or comparison).
5. If saved, update the index and log.

### Fetch news (`/ufo-news`)

When the user asks to pull in fresh UFO/UAP/alien coverage from the web:

- This workflow uses **parallel agent teams** (see `.claude/skills/ufo-news/SKILL.md` for the full protocol).
- Phase 1: fan out `Agent` calls — one per search track — to collect candidate URLs.
- Phase 2: main agent dedupes against `raw/` and `wiki/index.md`, presents candidates, waits for user pick.
- Phase 3: fan out one fetch agent per chosen URL; each writes its own file to `raw/inbox/`.
- Phase 4: fan out one analysis agent per saved file — read-only, returns structured output.
- Phase 5: main agent serially merges into shared files (`index.md`, `log.md`, entity/concept pages).
- Phase 6: report, including cross-connections between the new sources.

Parallel agents must be dispatched in a **single message with multiple `Agent` tool calls**. Subagents have no shared memory — every prompt must be self-contained. Only the main agent writes to `index.md`, `log.md`, and existing entity/concept pages.

### Lint

When the user asks to health-check the wiki:

- Look for contradictions between pages.
- Find stale claims superseded by newer sources.
- Identify orphan pages (no inbound links from other pages).
- Flag concepts mentioned but lacking their own page.
- Suggest missing cross-references.
- Suggest questions to investigate or sources to find.
- Report findings and fix issues with user approval.

## Formatting guidelines

- Write clearly and concisely. The wiki is a reference, not prose.
- Use headers, bullet points, and tables over long paragraphs.
- When a source makes a claim, note it as a claim with the source cited: `According to [[src-paper-name]], ...`
- When sources contradict each other, note the contradiction explicitly.
- Bold key terms on first mention within a page.

## Cross-referencing

- When creating or updating any page, scan for opportunities to link to existing pages.
- When a new page is relevant to existing pages, update those existing pages with links back.
- The goal is a densely linked graph. Every page should have both outbound and inbound links.

## Index maintenance

`wiki/index.md` is organized by category. Each entry is one line:
```
- [[page-name]] — one-line summary
```
Keep it sorted alphabetically within each category. Update it on every ingest and whenever pages are added or removed.

## Log format

`wiki/log.md` entries use this format for parseability:
```
## [YYYY-MM-DD] action | description

Details of what happened.
```

Actions: `ingest`, `query`, `lint`, `update`, `init`.

## Skills

User-invocable slash commands live in `.claude/skills/`:

- `/ingest <path>` — full ingest workflow for one file (or all of `raw/inbox/`).
- `/ufo-news [topic]` — parallel web search + ingest for fresh UFO/UAP/alien news.
- `/query <question>` — answer a question from the wiki with citations.
- `/save <title>` — save the last query answer as a permanent wiki page.
- `/lint` — health-check the wiki.
- `/wiki-help` — list commands and show architecture.
