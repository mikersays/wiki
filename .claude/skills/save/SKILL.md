---
name: save
description: Save a query answer, analysis, or synthesis as a new wiki page. Use after a query produces a substantial answer worth preserving in the knowledge base.
argument-hint: "<page-title>"
user-invocable: true
allowed-tools: Read Write Edit Glob Grep
---

# Save to Wiki

Save the most recent query answer or analysis as a new wiki page.

Page title: `$ARGUMENTS`

## Steps

1. Take the most recent substantial answer from this conversation and format it as a proper wiki page.

2. **Create the page** at `wiki/<kebab-case-title>.md` with:
   - Frontmatter: `title`, `type: analysis` (or `comparison` if it compares things), `created`, `updated`
   - Clean, well-structured content with `[[wikilinks]]` to all referenced pages.
   - A "Sources" section at the bottom listing the wiki pages that informed the analysis.

3. **Update existing pages** that are referenced by this analysis — add a backlink to the new page where relevant.

4. **Update `wiki/index.md`** — add the new page under the Analyses category.

5. **Update `wiki/log.md`**:
   ```
   ## [YYYY-MM-DD] query | <Page Title>

   Saved query result as [[page-name]]. References N existing pages.
   ```

6. Confirm to the user that the page was saved and show which pages were updated.
