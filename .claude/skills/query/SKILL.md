---
name: query
description: Ask a question against a vault. Searches the vault's index, reads relevant pages, and synthesizes an answer with citations. Use when exploring a knowledge base or asking questions about ingested sources.
argument-hint: "[vault] <your question>"
user-invocable: true
allowed-tools: Read Glob Grep Bash(ls *)
effort: high
---

# Query a Vault

Answer the following question using one of the wiki's vaults as the primary source of knowledge:

> $ARGUMENTS

## Resolve the vault first

1. List top-level directories that contain a `wiki/` subfolder — those are the available vaults.
2. If `$ARGUMENTS` begins with a vault name (a single bare token that matches a vault), strip it off and use it as the vault. The rest is the question.
3. Otherwise, if there is exactly one vault, default to it.
4. Otherwise, ask the user which vault to query.

The query is scoped to a single vault — never read pages from other vaults to answer it.

## Steps

1. **Read `<vault>/wiki/index.md`** to identify which pages are likely relevant to this question.

2. **Read the relevant pages**. If the question is broad, read more pages. If narrow, just the most relevant ones. Use Grep to search wiki pages if the index alone isn't sufficient to find what you need. Restrict all searches to `<vault>/wiki/`.

3. **Synthesize an answer** that:
   - Directly answers the question.
   - Cites wiki pages using `[[wikilinks]]` so the user can follow up.
   - Notes where the wiki has contradictory information from different sources.
   - Notes where the wiki has gaps — things that would help answer the question but aren't covered yet.

4. **Suggest filing**: If the answer is substantial (a comparison, an analysis, a synthesis that connects multiple pages), suggest saving it as a new wiki page in this vault. Ask the user if they'd like to save it. If they approve, use `/save` to file it.

## Guidelines

- Ground answers in what the vault actually says. Don't fabricate information not present in the wiki pages.
- If the vault doesn't have enough information to answer, say so and suggest what sources might fill the gap.
- Keep the answer concise and scannable — headers, bullets, and tables where appropriate.
- If the question touches on something the vault hasn't covered yet, note it as a gap worth investigating.
- Mention the vault name in the answer header so the user knows which knowledge base you drew from.
