---
name: query
description: Ask a question against the wiki. Searches the index, reads relevant pages, and synthesizes an answer with citations. Use when exploring the knowledge base or asking questions about ingested sources.
argument-hint: "<your question>"
user-invocable: true
allowed-tools: Read Glob Grep
effort: high
---

# Query the Wiki

Answer the following question using the wiki as the primary source of knowledge:

> $ARGUMENTS

## Steps

1. **Read `wiki/index.md`** to identify which pages are likely relevant to this question.

2. **Read the relevant pages**. If the question is broad, read more pages. If narrow, just the most relevant ones. Use Grep to search wiki pages if the index alone isn't sufficient to find what you need.

3. **Synthesize an answer** that:
   - Directly answers the question.
   - Cites wiki pages using `[[wikilinks]]` so the user can follow up.
   - Notes where the wiki has contradictory information from different sources.
   - Notes where the wiki has gaps — things that would help answer the question but aren't covered yet.

4. **Suggest filing**: If the answer is substantial (a comparison, an analysis, a synthesis that connects multiple pages), suggest saving it as a new wiki page. Ask the user if they'd like to save it. If they approve, use `/save` to file it.

## Guidelines

- Ground answers in what the wiki actually says. Don't fabricate information not present in the wiki pages.
- If the wiki doesn't have enough information to answer, say so and suggest what sources might fill the gap.
- Keep the answer concise and scannable — headers, bullets, and tables where appropriate.
- If the question touches on something the wiki hasn't covered yet, note it as a gap worth investigating.
