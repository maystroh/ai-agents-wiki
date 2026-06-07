---
date: 2026-06-07
pages_audited: 57
issues_found: 16
---

# Wiki Health Report — 2026-06-07

## Summary

The wiki is in good structural shape: 57 pages are well-organized, the tag index is consistent, and all pages are reachable from `index.md`. The most urgent fix is a mislabeled cross-reference in `closing-the-loop.md` that incorrectly calls verification "Pillar 1 of Agents 2.0" when `agents-evolution.md` defines Pillar 1 as Explicit Planning. The biggest structural gap is that `agent-memory.md` is a central concept page with no inbound links from four closely related concept pages that explicitly depend on it (agents-evolution Pillar 3, context-engineering, agent-runtime, subagent-patterns). Eight cross-reference additions and one label correction have been applied as part of this audit.

---

## 🔴 Contradictions

### 1. Verification mislabeled as "Pillar 1 of Agents 2.0"

- **Page A:** `concepts/closing-the-loop.md`, See Also section, line 100:
  > `[[agents-evolution]] — verification as Pillar 1 of Agents 2.0`
- **Page B:** `concepts/agents-evolution.md`, Pillar 1 section:
  > `### Pillar 1 — Explicit Planning`

Pillar 1 in `agents-evolution.md` is **Explicit Planning**. Verification is not one of the four pillars (Planning, Delegation, Persistent Memory, Context Engineering). The wikilink label in `closing-the-loop.md` is wrong and will mislead readers navigating to `agents-evolution.md`.

**Suggested fix:** Change the label to `[[agents-evolution]] — Agent 2.0 architecture; verification connects to Pillar 3 (Persistent Memory) via the outer loop` — or simply `[[agents-evolution]] — how deep agents are structured to support verification`.

**Status: Fixed in Step 5** (label corrected in `closing-the-loop.md`).

---

## 🟡 Stale Claims

None found. All source dates range from 2025-10 to 2026-05-29 and no concept page conclusion is explicitly reversed by a newer source. The benchmark numbers in `automated-research.md` (SWE-Bench 93.9%, METR 12hr horizon, Claude Mythos 52× speedup) are sourced from Import AI 455 (2026-05-04) and have no superseding source in the wiki yet.

---

## 🔵 Orphan Pages

None found. All 57 `.md` files in `outputs/` are linked from `index.md`, which serves as the master navigation page. However, seven source pages have no inbound links from any concept page — they are reachable only through `index.md`:

- `sources/ai-startups/box-ceo-ai-company.md`
- `sources/ai-startups/gary-vee-ai-opportunity.md`
- `sources/machine-learning/jensen-huang-compute.md`
- `sources/machine-learning/personal-ai-gary-tan.md`
- `sources/misc/data-aggregation-not-a-moat.md`
- `sources/ai-agents/boris-cherny-claude-code.md`
- `sources/ai-agents/omni-analytics-harness.md`

These are not orphans by the strict definition (they are in `index.md`) but they are weakly integrated into the concept graph. Future ingest runs should consider whether concepts from these sources (e.g., "accountability gap" from box-ceo, "always-on compute" from Jensen Huang, "tokenmaxxing" from Boris Cherny) belong in existing or new concept pages.

---

## 🟢 Missing Concept Pages

### 1. Prompt Engineering / Eval-Driven Prompt Design

**Sources that mention it:** `prompting-playbook` (central), `testing-skills`, `evals-for-taste`, `why-engineers-struggle`, `tool-skill-subagent-decomposition`

**What the page should cover:** The craft of writing effective LLM prompts as an engineering discipline distinct from context engineering (which covers layout/loading) — specifically: role/guidelines/policy/tone separation via XML; eval-driven iteration (write evals before writing prompts); output contracts; the harness-vs-prompt failure diagnosis framework (is this failure about what the agent does or how it does it?); and the score-after-reasons calibration pattern for LLM judges.

**Why it earns its own page:** `context-engineering.md` covers token placement and cache strategy. `evals-and-graders.md` covers the measurement framework. Neither covers the craft of writing the prompt content itself. The `prompting-playbook` source is the only Anthropic-sourced prompt-writing methodology in the wiki and has no corresponding concept page.

---

### 2. AGENTS.md / CLAUDE.md Best Practices

**Sources that mention it:** `writing-good-agents` (dedicated source), `agents-2.0-deep-agents` (Pillar 4), `inner-loop-vs-outer-loop`, `agent-skills-tips` (Skills vs AGENTS.md comparison), `codex-maxxing-jason-liu` (AGENTS.md as instructional layer in vault)

**What the page should cover:** What goes in AGENTS.md (tool usage rules, workflow constraints, gotchas), what doesn't (codebase overviews — agents navigate equally well without them), the ETH Zurich finding (auto-generated reduces success 3%, human-written improves 4% but increases cost 19%), the cost model (loaded every session, every line has a tax), and the design decision: AGENTS.md vs Skills (always-loaded config vs conditionally-triggered knowledge).

**Why it earns its own page:** The ETH Zurich cost/benefit finding is non-obvious and cross-referenced across three concept pages without synthesis. The Skills vs AGENTS.md design decision has practical implications for every agent builder. Currently, users who search for "what should I put in AGENTS.md" must piece together guidance from `agents-evolution.md`, `agent-skills.md`, and `inner-outer-loop.md`.

---

## 🔗 Missing Cross-References

The following pairs of concept pages are directly related but have no `[[wikilink]]` connecting them. All eight have been added as part of Step 5.

1. **`agent-engineering.md` → `evals-and-graders.md`** — Mindset Shift 4 in `agent-engineering.md` is "Evals Over Unit Tests" (Pass^k, LLM-as-judge, tracing). This is the core topic of `evals-and-graders.md`. The reverse link already exists (`evals-and-graders.md` cites `agent-engineering` in Related Concepts), but `agent-engineering.md`'s See Also omits `evals-and-graders`.

2. **`agents-evolution.md` → `agent-memory.md`** — Pillar 3 of Agent 2.0 is "Persistent Memory" — the entire content of `agent-memory.md`. Yet `agents-evolution.md`'s See Also links to `context-engineering` and `agent-harness` but not `agent-memory`. A reader following Pillar 3 has no path to the dedicated memory page.

3. **`automated-research.md` → `evals-and-graders.md`** — "The Eval is the Bottleneck" is a full section of `automated-research.md`. The eval design requirements for autoresearch (held-out, evolvable, reflects production) are a specialized application of the content in `evals-and-graders.md`. Neither page links to the other.

4. **`evals-and-graders.md` → `automated-research.md`** — Autoresearch is the ultimate hill-climbing workflow: eval-driven improvement of model weights rather than prompts. `evals-and-graders.md`'s Related Concepts links to `closing-the-loop` and `agent-skills` but not to `automated-research`, which is the highest-leverage application of the eval methodology.

5. **`context-engineering.md` → `agent-memory.md`** — `agent-memory.md` explicitly states: "Memory architecture is the implementation of the outer loop... memory determines what's available; context engineering determines what to load." Yet `context-engineering.md`'s See Also does not link to `agent-memory.md`, even though the two concepts are tightly coupled design decisions for every agentic system.

6. **`closing-the-loop.md` → `agent-harness.md`** — Spotify's scaffolded verification approach (verifiers exposed as a single MCP tool, LLM judge comparing diff to original prompt) is a harness-layer implementation. `closing-the-loop.md` describes this pattern in detail but its See Also links only to `inner-outer-loop`, `agent-engineering`, and `agents-evolution` — not `agent-harness`.

7. **`agent-runtime.md` → `agent-memory.md`** — The runtime provides the filesystem and lifecycle controller that memory architecture depends on. Managed Agents' brain/hands decoupling (covered in `agent-harness.md`) is also a runtime concern. `agent-runtime.md`'s See Also links to `agent-harness` but not to `agent-memory`.

8. **`subagent-patterns.md` → `agent-memory.md`** — `agent-memory.md` covers multi-agent memory scopes (org-wide read-only, agent-local read-write, optimistic concurrency). These scopes are a key design decision for multi-agent systems described in `subagent-patterns.md`. The pages don't link to each other.

---

## 🔍 Data Gaps

### 1. DeepMind intrinsic self-critique paper — no arXiv citation or source page

- **Page:** `concepts/closing-the-loop.md` and `concepts/inner-outer-loop.md`
- **Claim:** "DeepMind's intrinsic self-critique paper: a single LLM checks its own plan step-by-step against task rules after each action — no external signal — boosted planning success from **50% → 89%**."
- **Gap:** No arXiv ID, no author, no date, no source page in the wiki. This is the most-cited unsourced empirical claim in the wiki (appears in two concept pages).
- **Web search could resolve:** Yes — searching "DeepMind self-critique planning 50 89 percent" should find the paper.

---

### 2. SkillsBench paper — citation present but no source page

- **Page:** `concepts/agent-skills.md`
- **Claim:** "SkillsBench counted 47,000+ skills across 6,300+ repos. Most are AI-generated and 'vibe-checked' with a handful of manual runs." And: "Self-generated Skills provide no benefit on average, showing that models cannot reliably author the procedural knowledge they benefit from consuming." — cited as `arXiv 2602.12670`.
- **Gap:** The arXiv ID is present (2602.12670 = February 2026) but there is no source page (`sources/` entry) for this paper. It is the empirical foundation for skill retirement and testing guidance but is not browseable in the wiki.
- **Web search could resolve:** Yes — arXiv lookup on 2602.12670 gives full citation and abstract.

---

### 3. Recursive Superintelligence funding claim — unsourced

- **Page:** `concepts/automated-research.md`
- **Claim:** "Multiple startups: Recursive Superintelligence ($500M raised), Mirendil — explicitly targeting automated AI R&D"
- **Gap:** The $500M raised figure is a specific funding number with no source. If this is stale or incorrect it could mislead readers assessing the market.
- **Web search could resolve:** Yes — funding rounds are covered by TechCrunch, Crunchbase, etc.

---

### 4. Claude Code source leak claim — stated as fact, no source

- **Page:** `concepts/agent-harness.md`
- **Claim:** "The Claude Code source (leaked March 2026, 1,906 files) confirmed disciplined narrow tooling throughout — consistent with the thin harness discipline."
- **Gap:** The specific claim (March 2026 date, 1,906 file count) is stated as settled fact, but there is no source page documenting the leak or where this analysis comes from.
- **Web search could resolve:** Partially — confirming the leak's details and the specific architectural conclusions drawn from it.

---

### 5. Cognition containerized-kernel claim — attributed but unsourced

- **Page:** `concepts/agent-runtime.md`
- **Claim:** "Cognition found that containerized agents share a kernel — a single compromised session can reach every other container's filesystem."
- **Gap:** This security claim is attributed to Cognition (makers of Devin) but there is no source page for where Cognition published or stated this finding.
- **Web search could resolve:** Partially — searching Cognition's engineering blog or security writeups.

---

## ❓ Open Questions

1. **When does model capability make harness investment obsolete?** The wiki simultaneously presents "build to delete / thin harness" as the correct direction (Bitter Lesson, harness-as-90-day-artifact) and increasingly complex managed agent architectures (brain/hands decoupling, DSL-based verifiable harnesses, dreaming multi-agent harnesses). At what model capability threshold does harness sophistication stop compounding and start accumulating debt — and how do practitioners detect that threshold before they've built too much?

2. **How do you evaluate long-horizon agentic tasks where intermediate-process quality matters?** Current eval patterns (grader types, hill-climbing, QA loops) focus on final-output quality. For 50-step agents where planning strategy, recovery behavior, and resource usage matter as much as the final artifact, how do you build evals that test the right thing without either over-constraining the agent's approach or requiring human review of every intermediate step?

3. **Does shared memory in multi-agent systems undermine the "fresh perspective" argument for subagents?** The wiki's strongest case for subagents is a "fresh perspective" (code writer vs. reviewer who has seen nothing). But with Managed Agents, sub-agents share org-wide memory stores. Does reading from shared memory before producing output reintroduce the confirmation bias that a clean context was supposed to eliminate? When and how should memory access be scoped per-role?

4. **Can autoresearch eventually absorb the human taste function, or is jaggedness permanently structural?** The wiki documents autoresearch compounding fast for verifiable tasks (code, math, formal benchmarks) but acknowledges the model's jaggedness on softer domains (aesthetics, specification quality, edge case judgment). If the RL reward signal can only be defined over verifiable outputs, does this create a permanent ceiling on what autoresearch can improve — and what does that mean for the Jack Clark 60% by 2028 forecast?

5. **Is the DSL-based harness a pattern for trust or a pattern for correctness — and does the distinction matter for adoption?** Elicit's AshPL approach is presented as solving legibility and iteration fidelity. But "faithful execution" (the system literally cannot do something other than what the DSL specifies) is also a correctness guarantee. Are practitioners who need trust (audit trails, accountability) solving a different problem than those who need correctness (no plan drift, reproducibility) — and does the engineering effort required ($500K+ in the AshPL case) only make sense if you need both?

---

## 📚 Suggested New Sources

1. **SkillsBench paper (arXiv:2602.12670)** — Referenced in `agent-skills.md` as the empirical foundation for skill testing and retirement guidance ("self-generated skills provide no benefit on average"). Creating a source page for this paper would make the evidence base browseable and allow the concept page to cite it more precisely. Priority: high — this shapes one of the most actionable guidance sections in the wiki.

2. **DeepMind intrinsic self-critique paper (date unknown, ~2025)** — Referenced in both `closing-the-loop.md` and `inner-outer-loop.md` as evidence for spontaneous verification (50%→89% planning success). A source page would resolve the citation gap and let readers evaluate the experimental conditions. Priority: high — this claim appears twice in the wiki without a source.

3. **ETH Zurich AGENTS.md research (referenced in `writing-good-agents.md`)** — Cited as producing the key findings that auto-generated AGENTS.md reduces success by ~3% while increasing cost 20%+, and human-written improves only ~4% at 19% cost increase. This is a foundational evidence-based finding quoted across two concept pages. A source page would allow a new "AGENTS.md Best Practices" concept page to cite it properly.

4. **PostTrainBench and MLE-Bench papers (referenced in `automated-research.md`)** — `import-ai-455.md` cites PostTrainBench (AI achieves 25–28% uplift vs human 51%) and MLE-Bench (16.9%→64.4%). These are core evidence for the automated AI R&D thesis but have no source pages. An ingest of these papers would strengthen the `automated-research.md` concept page with traceable evidence.

5. **Anthropic's model introspection research paper (referenced as Oct 2025 in `closing-the-loop.md`)** — Cited as showing "Claude can distinguish between artificially injected outputs and its own generated ones — a mechanism that improves meta-task performance." This is a safety-relevant claim (self-awareness as a reliability primitive) that appears without a citable source. A source page for the Anthropic introspection paper would ground the spontaneous verification section in primary research.
