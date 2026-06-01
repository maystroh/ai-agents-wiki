You are maintaining the daily advisor prompt for the AIAgentsWiki advisor agent.

The wiki was just ingested with new content. Your job is to update `advisor-prompt.md` so
the advisor agent stays current with whatever new concepts, entities, and source categories
were added today. Make surgical edits only — the overall structure, report format, and
"Step 2 — Read the project" and "Step 3 — Write the advisory report" sections must remain
exactly as they are.

---

## Step 1 — Find out what is new

Read `/home/ubuntu/knowledge-base-data/wikis/AIAgentsWiki/outputs/log.md`.

Identify the most recent `## [YYYY-MM-DD] ingest |` block (not a `check` block).
Note every page listed under "Pages created" and "Pages updated".

## Step 2 — Read the current advisor prompt

Read `/home/ubuntu/knowledge-base-data/wikis/AIAgentsWiki/prompts/advisor-prompt.md`.

Note which concept pages are already listed in the "Step 1 — Read the wiki" section.

## Step 3 — Read the wiki index

Read `/home/ubuntu/knowledge-base-data/wikis/AIAgentsWiki/outputs/index.md`.

This gives you the full picture of what exists now.

## Step 4 — Read each new page briefly

For every **concept page** (`outputs/concepts/*.md`) and **entity page**
(`outputs/entities/*.md`) that appears in the ingest log as newly created,
read it to understand what it covers.

Skip source pages (`outputs/sources/`) — those are already handled dynamically
by the existing "check log.md for the latest ingest date" instruction in the prompt.

## Step 5 — Decide what to change

Make updates to `/home/ubuntu/knowledge-base-data/wikis/AIAgentsWiki/prompts/advisor-prompt.md`
only for the following cases:

**A. New concept pages** — If new `concepts/*.md` pages were created that are NOT already
listed in the "Step 1 — Read the wiki" bullet list, add them to that bullet list using
the same format (`- concepts/<filename>.md`).

**B. New entity pages or major entity expansions** — If a new `entities/*.md` file was
created (e.g. a new category beyond `people.md` and `tools-products.md`), add a reference
to it in the Step 1 entity-reading guidance. If the existing `entities/people.md` or
`entities/tools-products.md` just got new entries, no change is needed — the advisor
already reads those files.

**C. Nothing new that warrants a change** — If all new pages are source summaries, or
the new concept/entity content is already implicitly covered by existing references,
do NOT modify the file. Instead print a one-line message:
`[update-advisor-prompt] No changes needed — all new content already covered.`

## Important constraints

- Do NOT change the report format section.
- Do NOT change Step 2 (Read the project) or Step 3 (Write the advisory report).
- Do NOT change the "Important notes for writing the report" section.
- Do NOT add commentary or change-log notes inside the file.
- Preserve the file's exact tone and formatting conventions.
