---
name: audit
description: Audit a vault for schema compliance. Mechanical checks against the rules in CLAUDE.md — frontmatter, filenames, wikilink resolution, index coverage, log format, and vault structure. Reports violations and offers to auto-fix the mechanical ones.
argument-hint: "[vault] [--fix]"
user-invocable: true
allowed-tools: Read Glob Grep Edit Write Bash(ls *) Bash(grep *) Bash(awk *) Bash(sort *) Bash(comm *) Bash(wc *) Bash(date *)
effort: high
---

# Audit a Vault

Mechanically verify that a vault complies with the schema and conventions in the top-level `CLAUDE.md`. This skill is **deterministic** — it checks rules, not judgment calls. (For semantic health — contradictions, gaps, stale claims — use `/lint` instead.)

## Resolve the vault first

1. List top-level directories that contain a `wiki/` subfolder — those are the available vaults.
2. If `$ARGUMENTS` names a vault, audit that one. Strip a trailing `--fix` flag if present and remember it.
3. Otherwise, if there is exactly one vault, audit it.
4. Otherwise, ask the user which vault to audit.

If `--fix` is in `$ARGUMENTS`, perform mechanical auto-fixes after reporting (see "Auto-fix" below). Without it, only report.

## Compliance rules (per top-level `CLAUDE.md`)

### Vault structure
- `<vault>/wiki/`, `<vault>/wiki/index.md`, `<vault>/wiki/log.md` must exist.
- `<vault>/raw/` and `<vault>/raw/inbox/` must exist.

### Page frontmatter
Every `<vault>/wiki/*.md` page (except `index.md` and `log.md`) must have YAML frontmatter with:
- `title` — non-empty string
- `type` — one of: `source`, `entity`, `concept`, `analysis`, `comparison`
- `created` — `YYYY-MM-DD`
- `updated` — `YYYY-MM-DD`, must be `>= created`

Source pages additionally must have:
- `source_file` — path that resolves under `<vault>/raw/...` and points to an existing file
- `author` — non-empty string (or `"Staff"` if attribution is absent)
- `date` — `YYYY-MM-DD` (the date of the original source)

### Filename rules
- All page filenames are kebab-case: lowercase ASCII letters, digits, and hyphens only. No spaces, underscores, or uppercase. Must end in `.md`.
- **Source pages** (`type: source`): filename must match `^src-[a-z0-9-]+-(\d{4})(-\d{2})?\.md$`. No outlet/publisher names. No spelled-out months.
- **Entity / concept / analysis / comparison pages**: filename must be kebab-case but has no `src-` prefix.

### Wikilink resolution
- Every `[[target]]` (or `[[target|alias]]`) inside any `<vault>/wiki/*.md` page must resolve to an existing page `<vault>/wiki/<target>.md`.
- No wikilink may reference paths outside the vault (e.g. `[[../other-vault/page]]` or any `[[target]]` whose body contains `/`).

### Index coverage
- Every page file in `<vault>/wiki/` (except `index.md`, `log.md`) must appear as a `[[stem]]` somewhere in `index.md`.
- Every `[[stem]]` referenced in `index.md` must resolve to an existing page.
- Index entries should follow the format `- [[stem]] — <summary>` (em-dash). Lines that look like index entries but don't follow the format are reported.

### Log format
- Every header in `<vault>/wiki/log.md` that starts with `## ` must match `^## \[\d{4}-\d{2}-\d{2}\] (ingest|query|lint|update|init|audit) \| .+$`.

## Steps

1. **Resolve the vault** as described above.

2. **Run each check** below in order. Collect violations into a structured report. Use `Glob`, `Grep`, and `Bash` (`ls`, `grep`, `awk`, `sort`, `comm`) — don't read every file individually if a single grep across the directory will do.

   ### Check 1 — Vault structure
   Verify the required directories and files exist. Missing pieces are critical.

   ### Check 2 — Frontmatter
   For each page, read just the frontmatter block (lines between the first two `---`). Validate required keys, type whitelist, date format, `created <= updated`. For source pages, also validate `source_file`, `author`, `date`, and that `source_file` points to a file that exists under `<vault>/raw/`.

   ### Check 3 — Filenames
   Glob `<vault>/wiki/*.md`, filter out `index.md` / `log.md`, check kebab-case. For each page whose frontmatter says `type: source`, also check the `src-<slug>-<yyyy>[-mm].md` pattern.

   ### Check 4 — Wikilink resolution
   Build the set of valid stems = filenames in `<vault>/wiki/` minus `.md`. Then grep `[[...]]` across all wiki pages, parse the target (strip `|alias`), and find any target not in the valid set or that contains a `/`.

   ### Check 5 — Index coverage
   Build the set of expected stems (every page minus `index.md`/`log.md`). Build the set of stems referenced in `index.md`. Report `expected - referenced` (missing from index) and `referenced - expected` (index entries pointing to non-existent pages). Also report index lines that begin with `- [[` but don't match `- \[\[[^]]+\]\] — .+`.

   ### Check 6 — Log format
   Grep all `^## ` lines in `log.md` and report any that don't match the expected pattern.

3. **Report findings** as a structured table per check. For each violation, name the file, line if applicable, and the rule that was violated. Include a summary at the top:
   ```
   Vault: <name>
   Pages audited: N
   Violations: <total> across <check count> checks
   Auto-fixable: M
   ```

4. **Auto-fix** (only if `--fix` was passed):
   - **Index coverage — missing entries**: append a placeholder entry `- [[stem]] — <auto-derived summary or "TODO: summary">` to `index.md` under a best-guess category (use the page's `type` to pick the section; if uncertain, append to a new `## Unsorted` section the user can move).
   - **Index coverage — stale entries pointing to deleted pages**: remove the entry.
   - **Frontmatter — missing `updated` but `created` present**: copy `created` into `updated`.
   - **Filename — uppercase or underscores**: don't auto-fix (this requires moving the file and updating every wikilink to it). Report only.
   - **Wikilink resolution — broken target**: don't auto-fix. Report only.
   - **Log format**: don't auto-fix. Report only.

   After auto-fixing, append to `<vault>/wiki/log.md`:
   ```
   ## [YYYY-MM-DD] audit | <Vault> compliance audit (--fix)

   Auto-fixed N issues: <breakdown>. <M remaining issues left for manual review>.
   ```

5. **Always** append to `<vault>/wiki/log.md` (even without `--fix`):
   ```
   ## [YYYY-MM-DD] audit | <Vault> compliance audit

   Found N violations across <check count> checks. <Optional one-line summary of the worst category>.
   ```

## Report format

Output a single message structured like this:

```
# Vault audit: <vault>

**Summary:** <N> violations across <K> checks. <auto-fixable M>.

## 1. Vault structure
✅ All required paths present.
   — or —
❌ Missing: <vault>/wiki/log.md

## 2. Frontmatter (<count> issues)
| File | Issue |
|------|-------|
| foo.md | missing `updated` |
| src-bar-2026.md | `type` is `srce` (not in whitelist) |
| ...

## 3. Filenames (<count> issues)
| File | Rule | Detail |
|------|------|--------|
| FooBar.md | kebab-case | uppercase characters |
| src-baz-jan-2026.md | source pattern | spelled-out month |
| ...

## 4. Wikilinks (<count> broken)
| File | Line | Target | Detail |
|------|------|--------|--------|
| concept.md | 12 | [[mising-page]] | target page not found |
| ...

## 5. Index coverage
- Missing from index (<N>): foo, bar, baz, ...
- Stale index entries (<M>): qux (points to non-existent qux.md)
- Malformed lines (<P>): index.md:42 — `- [[foo]]` (missing summary)

## 6. Log format (<count> bad headers)
| Line | Header | Issue |
|------|--------|-------|
| 17 | `## 2026-04-30 ingest \| ...` | missing `[ ]` around date |
| ...

## Suggested next steps
- Run with `--fix` to auto-resolve the M mechanical issues.
- Manually rename: <list>
- Manually fix wikilinks: <list>
```

## Guidelines

- **Be exact.** False positives waste user time. If a rule is ambiguous (e.g. an index line uses a regular dash instead of em-dash), warn but don't count as a hard violation.
- **Be efficient.** With hundreds of pages, prefer one grep over 200 reads. Use `grep -oE`, `awk`, and `comm` to compute set diffs.
- **Don't fabricate.** If you can't determine a category for an auto-fixed index entry, dump it under `## Unsorted` and let the user sort it.
- **Don't fix what you can't unambiguously fix.** Filename renames, broken wikilink targets, and content rewrites belong to `/lint` or manual review.
- **Report in the same vault you audited.** Always.
- **Don't cross vault boundaries.** Each audit is single-vault. If the user asks to audit "all vaults," run the skill once per vault and report each separately.
