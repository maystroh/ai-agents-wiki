You are maintaining the AI Agents Wiki at /home/ubuntu/knowledge-base-data/wikis/AIAgentsWiki/outputs/.

## Your task: ingest any new source files

### Step 1 — Read the schema
Read /home/ubuntu/knowledge-base-data/wikis/AIAgentsWiki/outputs/CLAUDE.md for page format conventions.

### Step 2 — Identify already-ingested files
Read /home/ubuntu/knowledge-base-data/wikis/AIAgentsWiki/outputs/log.md and collect every filename mentioned in ingest entries. This is your list of already-processed sources.

### Step 3 — Discover all current input files
Read /home/ubuntu/knowledge-base-data/wikis/AIAgentsWiki/input_files.json.

For each entry:
- If it's an exact file path: note it as a candidate
- If it ends with `/*`: run `find "<path>" -type f` recursively to list all files in that directory tree

Collect the full list of discovered files.

### Step 4 — Diff: find what is new
Compare the discovered files against the log. Any file NOT mentioned in log.md is new and must be processed. Ignore duplicate archive dates (e.g. a file with 2026-05-22 and 2026-05-23 for the same content — treat them as one source).

If there is nothing new, write a one-line entry to log.md:
`## [YYYY-MM-DD] check | No new files found`
Then stop.

### Step 5 — Process each new file

For each new file:

1. **Read the file** — understand what it is (article, transcript, newsletter, etc.)

2. **Create a source summary page** following CLAUDE.md conventions:
   - Path: `outputs/sources/<category>/<slug>.md`
   - Categories: use the raw directory structure (e.g. `philschmid/`, `ai-agents/`, `ai-startups/`, `machine-learning/`, `prompt-engineering/`, `misc/`, `karpathy/`)
   - YAML frontmatter: `title`, `author`, `date`, `url`, `tags`, `sources`, `updated`
   - Sections: Summary (3–5 bullets) → Key Insights → Concepts Touched → Notable Quotes
   - Use `[[wikilinks]]` for all cross-references

3. **Update relevant concept pages** — if the new source adds meaningfully new insight to an existing concept in `outputs/concepts/`, add a section or update the relevant part. Don't duplicate what's already there.

4. **Update entity pages** — if new people or tools are mentioned that aren't in `outputs/entities/people.md` or `outputs/entities/tools-products.md`, add entries.

### Step 6 — Update index.md
Read /home/ubuntu/knowledge-base-data/wikis/AIAgentsWiki/outputs/index.md and add rows for each new source page in the appropriate table. If a new source category doesn't have a section yet, add one.

### Step 7 — Update log.md
Append a new entry to /home/ubuntu/knowledge-base-data/wikis/AIAgentsWiki/outputs/log.md:

```
## [YYYY-MM-DD] ingest | <N> new sources from <categories>

**Sources ingested:**
- <date> <title> (<author/channel>)
...

**Pages created:**
- sources/<path>.md
...

**Pages updated:**
- <list of updated pages>
```

Use today's actual date in YYYY-MM-DD format.
