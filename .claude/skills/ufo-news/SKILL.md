---
name: ufo-news
description: Search the web for the latest UFO/UAP/alien/non-human-intelligence news and ingest the results into the wiki using parallel agent teams. Optionally accepts a focus topic to narrow the search (e.g. "grusch", "aaro", "congressional hearings"). Use when the user wants to pull in fresh coverage.
argument-hint: "[optional topic focus]"
user-invocable: true
allowed-tools: Agent WebSearch WebFetch Read Write Edit Glob Grep Bash(mv *) Bash(date *) Bash(ls *)
effort: high
---

# Fetch & Ingest Latest UFO/Alien News (Parallel)

Find recent UFO/UAP/alien/non-human-intelligence news and ingest into the wiki using **parallel agent teams**. The main agent orchestrates; subagents do the searching, fetching, and per-article analysis concurrently. Only the final merge into shared files (`wiki/index.md`, `wiki/log.md`, entity/concept pages) is serial.

Focus topic (optional): `$ARGUMENTS`

## Orchestration overview

```
Phase 1  SEARCH       →  N agents in parallel  (one per query track)
Phase 2  TRIAGE       →  main agent: dedupe, present, get user pick
Phase 3  FETCH+SAVE   →  M agents in parallel  (one per chosen article)
Phase 4  ANALYZE      →  M agents in parallel  (one per saved raw file)
Phase 5  MERGE        →  main agent: serial write of shared files
Phase 6  REPORT       →  main agent: summary + cross-connections
```

Launch parallel agents by sending **one message with multiple `Agent` tool calls** — this is how the harness runs them concurrently. Never serialize what can fan out.

---

## Phase 1 — Search (parallel)

Read `wiki/index.md` and list `raw/` filenames so you know what's already covered. Then plan **5-8 search tracks**. If `$ARGUMENTS` is empty, use tracks like:

- `congressional-hearings` — UAP hearings, NDAA, legislation
- `aaro` — AARO reports, leadership, case resolutions
- `whistleblowers` — Grusch, Elizondo, new disclosures
- `pentagon-dod` — military intercepts, incidents, policy
- `primary-sources` — aaro.mil, dni.gov, dod.mil, congress.gov
- `astrobiology` — exoplanet biosignatures, JWST, SETI
- `incidents` — named sightings, stranded-object events
- `international` — UK, France, Brazil, Japan UAP news

If `$ARGUMENTS` is provided, derive 3-5 targeted tracks around it instead.

**Dispatch one `Agent` (subagent_type: `Explore`, or `general-purpose` if Explore isn't suited) per track in a single message.** Each agent's prompt must be self-contained:

> You are one of several parallel search agents. Track: `<track name>`. Use `WebSearch` with 2-3 queries biased toward the last 30 days (today is `<today's date>`). Collect 3-6 reputable candidate URLs. Prefer: NYT, WaPo, Reuters, AP, Guardian, The Debrief, The War Zone, Ars Technica, Politico, Liberation Times, and primary sources (aaro.mil, dod.mil, congress.gov, nasa.gov, dni.gov). Skip: tabloids, YouTube, clickbait aggregators, rehashes without new reporting.
>
> Return a compact list, one per line:
> `<YYYY-MM-DD> | <outlet> | <headline> | <url>`
>
> Don't fetch full article bodies — just the metadata. Keep response under 300 words.

---

## Phase 2 — Triage (main agent, serial)

Collect all subagent outputs. Then:

1. **Dedupe** by URL and by headline similarity.
2. **Drop** anything already covered: grep `raw/` filenames and `wiki/index.md` for the headline's key entities/events.
3. **Rank** by freshness × outlet quality × novelty vs existing wiki.
4. Present the surviving 5-12 candidates to the user as a numbered table:

   ```
   | # | Date | Outlet | Headline | URL |
   ```

5. Ask: *"Which should I ingest? (numbers, 'all', or 'none')"*. Skip the prompt if the user already said "just ingest everything" when invoking.

---

## Phase 3 — Fetch + save raw (parallel)

For each chosen URL, **dispatch one `Agent` (general-purpose) in parallel** — one message, N tool calls. Each agent's prompt:

> You are one of several parallel fetch agents. URL: `<url>`. Use `WebFetch` to retrieve the article. Extract: headline, author(s), publication date (YYYY-MM-DD), outlet, full article body (strip ads/nav/related-links, keep paragraphs intact), and 1-3 notable direct quotes.
>
> Write the result to `raw/inbox/src-<kebab-topic>-<yyyy>[-mm].md` using this format — nothing else:
>
> ```markdown
> ---
> source_url: <url>
> outlet: <outlet>
> author: <authors or "Staff">
> date: <YYYY-MM-DD>
> fetched: <today>
> ---
>
> # <Headline>
>
> <Full article body, verbatim.>
> ```
>
> Naming: kebab-case topic slug, no outlet name, no spelled-out month. Include `-mm` only if a `yyyy`-only filename would collide. Before writing, `ls raw/ raw/inbox/` to check for collisions — if the file would duplicate an existing source, DON'T write; return "SKIPPED: duplicate of <existing>".
>
> If the fetch fails or returns paywalled/empty content, DON'T write a file. Return "FAILED: <reason>". Don't fabricate.
>
> Return one line: `SAVED: raw/inbox/<filename>` or `SKIPPED: ...` or `FAILED: ...`.

Collect the return lines. Keep only the `SAVED` files for the next phase.

---

## Phase 4 — Analyze (parallel, read-only)

For each saved file, **dispatch one `Agent` (general-purpose) in parallel**. Analysis agents only read — they do **not** write shared files. Their prompt:

> You are one of several parallel analysis agents. Raw source file: `<path>`. Also read `wiki/index.md` and any wiki pages obviously relevant to the source's topic (use Grep/Glob). Do not write anything. Return structured JSON-like output:
>
> ```
> SOURCE_PAGE_FILENAME: wiki/src-<slug>-<yyyy>[-mm].md
> SOURCE_PAGE_CONTENT: |
>   ---
>   title: <...>
>   type: source
>   source_file: raw/<...>
>   source_url: <...>
>   outlet: <...>
>   author: <...>
>   date: <YYYY-MM-DD>
>   created: <today>
>   updated: <today>
>   ---
>
>   ## Summary
>   <3-6 sentences, neutral tone, [[wikilinks]] for known entities/concepts>
>
>   ## Key Claims
>   - <claim 1> (attributed to X)
>   - ...
>
>   ## Notable Quotes
>   > "..." — <speaker>
>
>   ## Related Pages
>   - [[page1]]
>   - [[page2]]
>
> ENTITIES:
>   - name: <kebab-case-filename>
>     display: <Display Name>
>     type: person | org | program | aircraft | location
>     exists: true | false  (check wiki/<name>.md)
>     update_notes: <1-3 bullets: what new info this source adds, or full draft if new>
>   - ...
>
> CONCEPTS:
>   - name: <kebab-case-filename>
>     display: <Display Name>
>     exists: true | false
>     update_notes: <...>
>   - ...
>
> CROSS_LINKS:
>   - existing wiki pages that should now link to the new source page: [[...]], [[...]]
>
> INDEX_ENTRIES:
>   - category: Sources
>     line: "- [[src-<slug>]] — <one-line summary>"
>   - category: Entities
>     line: "- [[<new-entity>]] — <one-line>"
>   - ...
> ```
>
> Follow `CLAUDE.md` for naming and frontmatter. Keep summaries tight. Return under 900 words.

---

## Phase 5 — Merge (main agent, serial)

Shared files (`index.md`, `log.md`, entity/concept pages that may receive updates from multiple sources) must be written serially to avoid conflicts. The main agent:

1. **Group entity/concept updates by name** across all analysis outputs. If two sources both touch `david-grusch.md`, merge their `update_notes` before writing once.
2. **Write source pages** — each is unique per article, safe to write straight through.
3. **Create new entity/concept pages** using the drafted content.
4. **Update existing entity/concept pages** — read, append/merge the new info, add backlink to the source page, bump `updated`.
5. **Update `wiki/index.md`** — insert new entries under their categories, keep alphabetical order within each category.
6. **Append `wiki/log.md`**:
   ```
   ## [YYYY-MM-DD] ingest | UFO news sweep (<N> articles)

   Fetched via /ufo-news. Ingested N sources in parallel.
   New sources: [[src-a]], [[src-b]], ...
   New entities: [[...]]
   New concepts: [[...]]
   Updated: [[...]]
   ```
7. **Move** each `raw/inbox/<file>` → `raw/<file>` after its wiki pages are written. Use individual `mv` commands, not a wildcard — only move the files that successfully ingested.

Any agent-reported `FAILED` or `SKIPPED` items stay out of `raw/inbox/` logic only if the subagent didn't create a file; if a failed fetch somehow left a partial file, delete it first and note it.

---

## Phase 6 — Report

Summarize to the user:

- Searches dispatched / candidates found / candidates chosen / successfully ingested.
- New pages created, existing pages updated (by name).
- **Cross-connections**: same person/program/incident appearing across multiple new sources — explicitly link them.
- **Contradictions** between new stories and existing wiki content.
- Anything skipped or failed, and why.
- Suggested follow-ups: gaps, missing primary sources, stories worth a dedicated `/query`.

---

## Guidelines

- **Parallelism is the point**: always batch `Agent` calls into one message when they're independent. Phase 1, 3, and 4 each dispatch N agents in one shot.
- **Subagents don't share memory**: every prompt must be self-contained — URL, filename convention, output format, and today's date included inline.
- **Read-only in analysis**: analysis agents must not write `wiki/index.md`, `wiki/log.md`, or any entity/concept pages. Only the main agent touches shared files.
- **Source pages are per-agent safe** (unique paths) — fetch agents may write directly to `raw/inbox/`.
- **Dedupe twice**: once at triage (before fetching), once at fetch (before writing) — the world may have added dupes between phases.
- **No fabrication**: if a subagent says `FAILED`, it's failed. Don't invent content.
- **Respect `CLAUDE.md`**: filenames, frontmatter, wikilinks, index/log format all follow the project's existing conventions.
- **Freshness bias**: last 30 days unless the user explicitly asks for historical sweeps.
