# LLM Wiki Schema

This is a multi-vault personal knowledge base maintained by an LLM. The human curates sources and directs exploration. The LLM does all the writing, cross-referencing, and maintenance.

## Repo layout

```
CLAUDE.md             # This file — multi-vault schema and shared conventions
.claude/skills/       # Slash-command definitions (vault-aware)
<vault-name>/         # One folder per vault — e.g. `ufo/`
  CLAUDE.md           # Optional vault-specific guidance (topic, scope, exceptions)
  raw/inbox/          # New source documents waiting to be ingested
  raw/                # Ingested source documents (immutable after ingest)
  raw/assets/         # Downloaded images and attachments
  wiki/               # LLM-generated markdown pages (the wiki itself)
  wiki/index.md       # Content catalog — every page listed with summary and category
  wiki/log.md         # Chronological activity log
  .obsidian/          # Per-vault Obsidian config (each vault is its own Obsidian vault)
```

A **vault** is any top-level directory containing a `wiki/` subfolder. Currently: `ufo/`. To add a new vault, create the folder with `raw/inbox/`, `raw/assets/`, `wiki/index.md`, `wiki/log.md`, and (optionally) a `CLAUDE.md` describing its scope. Vaults are independent — pages and wikilinks never cross vault boundaries.

## Vault selection

Skills must always operate inside a single vault.

- If the user provides a path argument, the **first segment is the vault** (e.g. `ufo/raw/inbox/foo.md` → vault is `ufo`).
- Otherwise, list top-level directories containing a `wiki/` subfolder:
  - **Exactly one vault** → use it.
  - **Multiple vaults** → the first argument must be the vault name, e.g. `/query ufo what does the wiki say about AARO?`. If unclear, ask the user which vault.
- Never write to paths that aren't inside a vault. Never link a page in one vault to a page in another.

## Page conventions (shared across vaults)

- All wiki pages live in `<vault>/wiki/`.
- Use `[[wikilinks]]` for cross-references (Obsidian-style). Wikilinks are scoped to the vault.
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

New sources go in `<vault>/raw/inbox/`. When the user asks to ingest (or specifies a file path directly):

1. Resolve the vault from the path argument or the single-vault default.
2. If no path is given, scan `<vault>/raw/inbox/` for files to ingest.
3. Read the source document fully.
4. Discuss key takeaways with the user if they want interaction, or proceed if they say to just process it.
5. Create a source summary page in `<vault>/wiki/` with frontmatter, summary, key claims, and relevant quotes.
6. Update or create entity pages for important people, organizations, tools, etc. mentioned in the source.
7. Update or create concept pages for key ideas, methods, frameworks.
8. Add `[[wikilinks]]` in all new and updated pages to connect them to existing pages **in the same vault**.
9. Update `<vault>/wiki/index.md` with entries for all new pages.
10. Append an entry to `<vault>/wiki/log.md`.
11. Move the source file from `<vault>/raw/inbox/` to `<vault>/raw/` to mark it as ingested.
12. Report what was created and updated.

A single source typically touches 5-15 wiki pages.

### Query

When the user asks a question:

1. Resolve the vault.
2. Read `<vault>/wiki/index.md` to identify relevant pages.
3. Read the relevant pages.
4. Synthesize an answer with `[[wikilinks]]` citations to wiki pages.
5. If the answer is substantial and worth preserving, offer to save it as a new wiki page (type: analysis or comparison).
6. If saved, update the index and log.

### Lint

When the user asks to health-check a vault:

- Look for contradictions between pages.
- Find stale claims superseded by newer sources.
- Identify orphan pages (no inbound links from other pages).
- Flag concepts mentioned but lacking their own page.
- Suggest missing cross-references.
- Suggest questions to investigate or sources to find.
- Report findings and fix issues with user approval.

Lint operates on one vault at a time.

### Vault-scoped skills

Some skills only apply to a specific vault — see the skill's frontmatter for its `vault` field. Currently:

- `/ufo-news` — pinned to the `ufo/` vault. Searches the web for fresh UFO/UAP/alien coverage and ingests into `ufo/`.

If a vault-scoped skill is invoked when its target vault doesn't exist, the skill should refuse and explain.

## Formatting guidelines

- Write clearly and concisely. The wiki is a reference, not prose.
- Use headers, bullet points, and tables over long paragraphs.
- When a source makes a claim, note it as a claim with the source cited: `According to [[src-paper-name]], ...`
- When sources contradict each other, note the contradiction explicitly.
- Bold key terms on first mention within a page.

## Cross-referencing

- When creating or updating any page, scan for opportunities to link to existing pages **in the same vault**.
- When a new page is relevant to existing pages, update those existing pages with links back.
- The goal is a densely linked graph per vault. Every page should have both outbound and inbound links.
- Never wikilink across vault boundaries — vaults are independent knowledge bases.

## Index maintenance

`<vault>/wiki/index.md` is organized by category. Each entry is one line:
```
- [[page-name]] — one-line summary
```
Keep it sorted alphabetically within each category. Update it on every ingest and whenever pages are added or removed.

## Log format

`<vault>/wiki/log.md` entries use this format for parseability:
```
## [YYYY-MM-DD] action | description

Details of what happened.
```

Actions: `ingest`, `query`, `lint`, `audit`, `update`, `init`.

## Skills

User-invocable slash commands live in `.claude/skills/`:

| Command | Scope | Description |
|---------|-------|-------------|
| `/ingest [vault] [path]` | any vault | Full ingest workflow for one file (or all of `<vault>/raw/inbox/`). |
| `/query [vault] <question>` | any vault | Answer a question from the vault with citations. |
| `/save [vault] <title>` | any vault | Save the last query answer as a permanent wiki page. |
| `/lint [vault]` | any vault | Semantic health-check (contradictions, gaps, stale claims, suggested cross-references). |
| `/audit [vault] [--fix]` | any vault | Mechanical schema-compliance check (frontmatter, filenames, wikilink resolution, index coverage, log format). |
| `/wiki-help` | repo-wide | List vaults, commands, and architecture. |
| `/ufo-news [topic]` | `ufo/` only | Parallel web search + ingest for fresh UFO/UAP/alien news. |

When only one vault exists, the `[vault]` argument can be omitted and the skill defaults to it.
