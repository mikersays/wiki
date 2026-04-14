# LLM Wiki Schema

This is a personal knowledge base maintained by an LLM. The human curates sources and directs exploration. The LLM does all the writing, cross-referencing, and maintenance.

## Directory structure

```
raw/            # Immutable source documents (articles, papers, notes, images)
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
- Use descriptive filenames in kebab-case: `wiki/reinforcement-learning.md`, `wiki/src-attention-is-all-you-need.md`.

## Workflows

### Ingest

When the user adds a source to `raw/` and asks to ingest it:

1. Read the source document fully.
2. Discuss key takeaways with the user if they want interaction, or proceed if they say to just process it.
3. Create a source summary page in `wiki/` with frontmatter, summary, key claims, and relevant quotes.
4. Update or create entity pages for important people, organizations, tools, etc. mentioned in the source.
5. Update or create concept pages for key ideas, methods, frameworks.
6. Add `[[wikilinks]]` in all new and updated pages to connect them to existing pages.
7. Update `wiki/index.md` with entries for all new pages.
8. Append an entry to `wiki/log.md`.
9. Report what was created and updated.

A single source typically touches 5-15 wiki pages.

### Query

When the user asks a question:

1. Read `wiki/index.md` to identify relevant pages.
2. Read the relevant pages.
3. Synthesize an answer with `[[wikilinks]]` citations to wiki pages.
4. If the answer is substantial and worth preserving, offer to save it as a new wiki page (type: analysis or comparison).
5. If saved, update the index and log.

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
