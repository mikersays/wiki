---
name: new-vault
description: Scaffold a new vault. Creates the directory layout (raw/inbox/, raw/assets/, wiki/), seeds index.md, log.md, and a vault-specific CLAUDE.md based on topic and scope you describe. Use when the user wants to start a new knowledge base alongside existing vaults.
argument-hint: "<vault-name> [\"topic statement\"]"
user-invocable: true
allowed-tools: Read Write Edit Glob Grep Bash(mkdir *) Bash(ls *) Bash(touch *) Bash(cp *) Bash(date *)
effort: medium
---

# Scaffold a New Vault

Create a new vault folder at the repo root with the standard layout and seed files. The vault becomes immediately usable by all vault-aware skills (`/ingest`, `/query`, `/save`, `/lint`, `/audit`).

## Resolve the vault name

`$ARGUMENTS` should be `<vault-name>` optionally followed by a topic statement in quotes.

1. Take the first whitespace-delimited token as the vault name. The rest (if any) is the topic statement.
2. If no name was given, ask: *"What should the new vault be called? (use kebab-case, e.g. `security`, `mlops`, `local-history`)"*
3. **Validate** the name:
   - Must match `^[a-z][a-z0-9-]*$` (kebab-case, starts with letter)
   - Must not collide with existing top-level entries: `.claude`, `.git`, `.obsidian` (if at root), `raw`, `wiki`, `node_modules`, or any existing vault folder
   - Must not be a reserved name: `assets`, `inbox`, `index`, `log`
4. **Refuse** with an explanation if validation fails. Don't proceed.

## Gather metadata

If the topic statement was passed inline, use it. Otherwise, ask the user three things — keep prompts short and offer to skip:

1. **Topic** — one sentence: *"What is this vault about?"* (e.g. "Security research notes, vulnerability advisories, and red-team tradecraft.")
2. **In scope** — 3-6 bullets the vault *should* cover. Skip-able with "skip" → use a single placeholder bullet `- TODO: define in-scope topics`.
3. **Out of scope** — 1-3 bullets the vault *should not* cover. Skip-able the same way.

Don't ask anything else. Other vault decisions can be added to the vault's CLAUDE.md later.

## Confirm before creating

Show the planned layout and metadata in a tight summary:

```
About to create vault `<name>/`:
  <name>/CLAUDE.md
  <name>/raw/inbox/.gitkeep
  <name>/raw/assets/.gitkeep
  <name>/wiki/index.md   (seeded with empty category sections)
  <name>/wiki/log.md     (seeded with init entry)

Topic: <one-line topic>
In scope: <count> bullets
Out of scope: <count> bullets

Proceed? (y/n)
```

Wait for explicit confirmation. If the user says no, abort cleanly.

## Steps to create

Run these in order:

1. **Create the directory tree:**
   ```
   mkdir -p <name>/raw/inbox <name>/raw/assets <name>/wiki
   touch <name>/raw/inbox/.gitkeep <name>/raw/assets/.gitkeep
   ```

2. **Write `<name>/CLAUDE.md`** using this template (fill in the placeholders from the metadata gathered above):

   ```markdown
   ---
   vault: <name>
   ---

   # <Display Name> Vault

   Topic: <topic statement>

   ## Scope

   In scope:
   - <bullet 1>
   - <bullet 2>
   - <...>

   Out of scope:
   - <bullet 1>
   - <...>

   ## Vault-specific notes

   - Source filenames follow the shared `src-<topic>-<yyyy>[-mm].md` convention. See top-level `CLAUDE.md` for naming rules.
   - Wikilinks are scoped to this vault — never link to pages in other vaults.
   ```

   Display Name = the vault name with hyphens replaced by spaces and the first letter of each word uppercased.

3. **Write `<name>/wiki/index.md`** seeded with empty categories — this is the canonical category set used by `/ingest`:

   ```markdown
   # <Display Name> Wiki Index

   Catalog of every page in this vault. Each line: `- [[page-name]] — one-line summary`.
   Sorted alphabetically within each category.

   ## Sources

   ## Entities

   ## Concepts

   ## Analyses

   ```

4. **Write `<name>/wiki/log.md`** with an init entry (use today's date):

   ```markdown
   # <Display Name> Vault Log

   Chronological activity log. Each entry: `## [YYYY-MM-DD] action | description`.

   ## [YYYY-MM-DD] init | Vault scaffolded

   Created via `/new-vault`. Topic: <one-line topic>. Empty wiki — drop sources in `<name>/raw/inbox/` and run `/ingest <name>` to begin.
   ```

5. **(Optional)** If another vault has an `.obsidian/` config, ask: *"Copy `.obsidian/` config from `<existing-vault>/`? (y/n)"*. If yes, copy `app.json`, `appearance.json`, `core-plugins.json` only — never the runtime state files (`workspace.json`, `graph.json`, `plugins/`, `themes/`). If there's no existing vault to copy from, skip this step silently.

   ```
   mkdir -p <name>/.obsidian
   cp <existing-vault>/.obsidian/{app,appearance,core-plugins}.json <name>/.obsidian/
   ```

6. **Verify** the structure was created:
   ```
   ls <name>/ <name>/raw/ <name>/raw/inbox/ <name>/raw/assets/ <name>/wiki/
   ```

7. **Report** to the user:
   - The path that was created
   - Where to drop sources: `<name>/raw/inbox/`
   - Next-step commands:
     ```
     /ingest <name> <name>/raw/inbox/<file>.md   # ingest a source
     /query <name> <question>                    # ask a question once you've ingested some sources
     /audit <name>                               # check schema compliance
     ```
   - A reminder to open `<name>/` in Obsidian as a separate vault if they want graph view.

## Guidelines

- **One vault per invocation.** Don't try to scaffold multiple vaults at once — too easy to lose track.
- **Don't overwrite.** If `<name>/` already exists, refuse and explain. Suggest the user pick a different name or remove the existing folder first.
- **Don't auto-commit.** Leave the new files staged or unstaged for the user to review. The user commits when ready.
- **Keep the seed minimal.** No example pages, no demo content. The vault is supposed to grow from real sources the user provides.
- **Don't touch existing vaults** during scaffolding. The new vault is independent — no shared pages, no cross-vault wikilinks.
- **Don't seed .gitignore patterns.** The repo-level `.gitignore` already globs `**/.obsidian/workspace.json` etc., so per-vault Obsidian state will be ignored automatically.
