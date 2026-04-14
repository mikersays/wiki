---
name: ingest
description: Ingest a source document into the wiki. Reads the source, creates a summary page, updates or creates entity and concept pages, wires up cross-references, and updates the index and log.
argument-hint: "<path-to-source>"
user-invocable: true
allowed-tools: Read Glob Grep Write Edit Bash(wc *)
effort: high
---

# Ingest Source

Ingest source documents into the wiki.

## Steps

1. **Find sources to ingest:**
   - If `$ARGUMENTS` contains a path, ingest that specific file.
   - If `$ARGUMENTS` is empty or says "all", scan `raw/inbox/` for all files and ingest each one.
   - If `raw/inbox/` is empty and no path was given, tell the user there's nothing to ingest.

2. **Read the source** in full. If it's a PDF, read it page by page. If it's an image, view it.

3. **Read the current state** of `wiki/index.md` to understand what pages already exist.

4. **Create a source summary page** in `wiki/` with this structure:
   - Filename: `wiki/src-<kebab-case-title>.md`
   - Frontmatter: `title`, `type: source`, `source_file` (path to raw document), `author`, `date` (of original source if known), `created`, `updated`
   - Sections: Summary, Key Claims, Notable Quotes (if any), Related Pages (wikilinks)

4. **Update or create entity pages** for important people, organizations, tools, projects, etc. mentioned in the source.
   - Filename: `wiki/<entity-name>.md`
   - Frontmatter: `title`, `type: entity`, `created`, `updated`
   - If the page already exists, update it with new information from this source and add a reference back to the source page.
   - If creating new, include all relevant information from this source and link to the source page.

5. **Update or create concept pages** for key ideas, methods, frameworks, theories.
   - Filename: `wiki/<concept-name>.md`
   - Frontmatter: `title`, `type: concept`, `created`, `updated`
   - Same create-or-update logic as entities.

6. **Cross-reference**: Go through all new and updated pages and add `[[wikilinks]]` wherever one page references a topic that has its own page. Also update *existing* pages that should now link to newly created pages.

7. **Update `wiki/index.md`**: Add entries for every new page under the appropriate category. Format: `- [[page-name]] — one-line summary`. Keep each category sorted alphabetically.

8. **Update `wiki/log.md`**: Append an entry:
   ```
   ## [YYYY-MM-DD] ingest | <Source Title>

   Ingested [[src-page-name]]. Created X new pages, updated Y existing pages.
   New: [[page1]], [[page2]], ...
   Updated: [[page3]], [[page4]], ...
   ```

9. **Move ingested source:** If the source was in `raw/inbox/`, move it to `raw/` to mark it as ingested.

10. **Report** to the user: summarize what was created and updated, and mention anything interesting — contradictions with existing pages, surprising connections, gaps worth investigating.

## Guidelines

- Use `[[wikilinks]]` everywhere, not markdown links.
- Write concisely. The wiki is a reference, not an essay.
- Note contradictions explicitly when new source data conflicts with existing wiki content.
- When uncertain about how to categorize something, prefer creating a page and linking it rather than omitting it.
- If the source references other works that seem important, mention them as potential future sources.
