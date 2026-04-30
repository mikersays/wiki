---
name: save
description: Save a query answer, analysis, or synthesis as a new page in a vault. Use after a query produces a substantial answer worth preserving in the knowledge base.
argument-hint: "[vault] <page-title>"
user-invocable: true
allowed-tools: Read Write Edit Glob Grep Bash(ls *)
---

# Save to Vault

Save the most recent query answer or analysis as a new page in a vault.

## Resolve the vault first

1. List top-level directories that contain a `wiki/` subfolder — those are the available vaults.
2. If the previous query was scoped to a specific vault, default to that one.
3. If `$ARGUMENTS` begins with a vault name (a single bare token that matches a vault), strip it off and use it as the vault. The rest is the page title.
4. Otherwise, if there is exactly one vault, default to it.
5. Otherwise, ask the user which vault to save into.

The page title (after vault resolution) is in `$ARGUMENTS`.

## Steps

1. Take the most recent substantial answer from this conversation and format it as a proper wiki page.

2. **Create the page** at `<vault>/wiki/<kebab-case-title>.md` with:
   - Frontmatter: `title`, `type: analysis` (or `comparison` if it compares things), `created`, `updated`
   - Clean, well-structured content with `[[wikilinks]]` to all referenced pages **in the same vault**.
   - A "Sources" section at the bottom listing the wiki pages that informed the analysis.

3. **Update existing pages** in the same vault that are referenced by this analysis — add a backlink to the new page where relevant.

4. **Update `<vault>/wiki/index.md`** — add the new page under the Analyses category.

5. **Update `<vault>/wiki/log.md`**:
   ```
   ## [YYYY-MM-DD] query | <Page Title>

   Saved query result as [[page-name]]. References N existing pages.
   ```

6. Confirm to the user that the page was saved, name the vault, and show which pages were updated.

## Guidelines

- All wikilinks must point to pages within the chosen vault — never link across vaults.
- Don't fabricate references. If a page wasn't actually consulted, don't cite it.
