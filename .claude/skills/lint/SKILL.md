---
name: lint
description: Health-check the wiki. Finds contradictions, orphan pages, missing cross-references, stale content, and gaps. Use periodically to keep the wiki healthy as it grows.
user-invocable: true
allowed-tools: Read Glob Grep
effort: high
---

# Lint the Wiki

Perform a comprehensive health check of the wiki.

## Steps

1. **Read `wiki/index.md`** and **list all files** in `wiki/` to check for pages missing from the index.

2. **Read every wiki page** (or as many as feasible if the wiki is very large).

3. **Check for each of the following issues:**

   ### Contradictions
   - Claims in one page that conflict with claims in another page.
   - Note which sources back each side.

   ### Stale content
   - Pages that reference information superseded by a newer source.
   - Pages with `updated` dates much older than recent ingests.

   ### Orphan pages
   - Pages with no inbound `[[wikilinks]]` from other pages.
   - These are disconnected from the graph and may need linking.

   ### Missing pages
   - `[[wikilinks]]` that point to pages that don't exist yet.
   - Concepts or entities mentioned frequently but lacking their own page.

   ### Missing cross-references
   - Pages that discuss the same topic but don't link to each other.
   - Entity pages that should reference each other.

   ### Index issues
   - Pages that exist in `wiki/` but aren't listed in `wiki/index.md`.
   - Index entries that point to pages that no longer exist.

   ### Gaps
   - Topics mentioned across multiple pages that could benefit from deeper investigation.
   - Questions the wiki raises but doesn't answer.
   - Sources referenced by existing sources that haven't been ingested.

4. **Report findings** organized by category (contradictions, orphans, gaps, etc.). For each issue, state what it is and suggest how to fix it.

5. **Offer to fix** mechanical issues (orphan links, missing index entries, missing cross-references) automatically. Wait for user approval before making changes.

6. **Append to `wiki/log.md`**:
   ```
   ## [YYYY-MM-DD] lint | Wiki health check

   Found N issues: X contradictions, Y orphans, Z missing references, ...
   ```
