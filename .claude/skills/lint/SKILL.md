---
name: lint
description: Health-check a vault. Finds contradictions, orphan pages, missing cross-references, stale content, and gaps. Use periodically to keep a vault healthy as it grows.
argument-hint: "[vault]"
user-invocable: true
allowed-tools: Read Glob Grep Bash(ls *)
effort: high
---

# Lint a Vault

Perform a comprehensive health check of one vault.

## Resolve the vault first

1. List top-level directories that contain a `wiki/` subfolder — those are the available vaults.
2. If `$ARGUMENTS` names a vault, lint that one.
3. Otherwise, if there is exactly one vault, lint it.
4. Otherwise, ask the user which vault to lint.

Lint operates on one vault at a time. Don't compare or link across vaults.

## Steps

1. **Read `<vault>/wiki/index.md`** and **list all files** in `<vault>/wiki/` to check for pages missing from the index.

2. **Read every wiki page** in the vault (or as many as feasible if the vault is very large).

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
   - Pages that exist in `<vault>/wiki/` but aren't listed in `<vault>/wiki/index.md`.
   - Index entries that point to pages that no longer exist.

   ### Gaps
   - Topics mentioned across multiple pages that could benefit from deeper investigation.
   - Questions the wiki raises but doesn't answer.
   - Sources referenced by existing sources that haven't been ingested.

4. **Report findings** organized by category (contradictions, orphans, gaps, etc.). For each issue, state what it is and suggest how to fix it. Mention the vault name in the report.

5. **Offer to fix** mechanical issues (orphan links, missing index entries, missing cross-references) automatically. Wait for user approval before making changes.

6. **Append to `<vault>/wiki/log.md`**:
   ```
   ## [YYYY-MM-DD] lint | Wiki health check

   Found N issues: X contradictions, Y orphans, Z missing references, ...
   ```
