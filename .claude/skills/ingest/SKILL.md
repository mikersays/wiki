---
name: ingest
description: Ingest a source document into a vault. Reads the source, creates a summary page, updates or creates entity and concept pages, wires up cross-references, and updates the vault's index and log.
argument-hint: "[vault] [path-to-source]"
user-invocable: true
allowed-tools: Read Glob Grep Write Edit Bash(wc *) Bash(ls *)
effort: high
---

# Ingest Source

Ingest a source document into one of the wiki's vaults.

## Resolve the vault first

`$ARGUMENTS` may be:

- empty
- a vault name (e.g. `ufo`)
- a path (e.g. `ufo/raw/inbox/foo.md` or `raw/inbox/foo.md`)
- `<vault> <path>` (e.g. `ufo raw/inbox/foo.md`)

Steps to resolve:

1. List top-level directories of the repo that contain a `wiki/` subfolder — those are the **available vaults**.
2. If `$ARGUMENTS` starts with a vault name, that's the vault. The remainder is the path.
3. Otherwise, if `$ARGUMENTS` is a path whose first segment is a vault name, that's the vault.
4. Otherwise, if there is **exactly one** vault, default to it.
5. Otherwise, ask the user which vault to ingest into.

All file paths below are relative to the repo root and must be inside the chosen vault.

## Steps

1. **Find sources to ingest:**
   - If a specific path was resolved, ingest that file.
   - If only a vault was given (no path), scan `<vault>/raw/inbox/` for files and ingest each one.
   - If `<vault>/raw/inbox/` is empty and no path was given, tell the user there's nothing to ingest.

2. **Read the source** in full. If it's a PDF, read it page by page. If it's an image, view it.

3. **Read the current state** of `<vault>/wiki/index.md` to understand what pages already exist.

4. **Create a source summary page** at `<vault>/wiki/src-<kebab-case-title>.md`:
   - Frontmatter: `title`, `type: source`, `source_file` (path to raw document inside this vault), `author`, `date` (of original source if known), `created`, `updated`
   - Sections: Summary, Key Claims, Notable Quotes (if any), Related Pages (wikilinks)

5. **Update or create entity pages** at `<vault>/wiki/<entity-name>.md` for important people, organizations, tools, projects, etc.
   - Frontmatter: `title`, `type: entity`, `created`, `updated`
   - If the page already exists, update it with new information from this source and add a reference back to the source page.
   - If creating new, include all relevant information from this source and link to the source page.

6. **Update or create concept pages** at `<vault>/wiki/<concept-name>.md` for key ideas, methods, frameworks, theories.
   - Frontmatter: `title`, `type: concept`, `created`, `updated`
   - Same create-or-update logic as entities.

7. **Cross-reference** within the vault: Go through all new and updated pages and add `[[wikilinks]]` wherever one page references a topic that has its own page in the same vault. Also update *existing* pages that should now link to newly created pages. Never wikilink to pages in other vaults.

8. **Update `<vault>/wiki/index.md`**: Add entries for every new page under the appropriate category. Format: `- [[page-name]] — one-line summary`. Keep each category sorted alphabetically.

9. **Update `<vault>/wiki/log.md`**: Append an entry:
   ```
   ## [YYYY-MM-DD] ingest | <Source Title>

   Ingested [[src-page-name]]. Created X new pages, updated Y existing pages.
   New: [[page1]], [[page2]], ...
   Updated: [[page3]], [[page4]], ...
   ```

10. **Move ingested source:** If the source was in `<vault>/raw/inbox/`, move it to `<vault>/raw/` to mark it as ingested.

11. **Report** to the user: name the vault, summarize what was created and updated, and mention anything interesting — contradictions with existing pages, surprising connections, gaps worth investigating.

## Guidelines

- Use `[[wikilinks]]` everywhere, not markdown links.
- Wikilinks are scoped to the vault — never link to pages in another vault.
- Write concisely. The wiki is a reference, not an essay.
- Note contradictions explicitly when new source data conflicts with existing wiki content.
- When uncertain about how to categorize something, prefer creating a page and linking it rather than omitting it.
- If the source references other works that seem important, mention them as potential future sources.
- Read `<vault>/CLAUDE.md` (if it exists) for vault-specific scope and conventions.
