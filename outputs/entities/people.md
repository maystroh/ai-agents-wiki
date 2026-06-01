---
title: People — Key Figures in AI Agent Engineering
tags:
  - entities
  - people
updated: 2026-05-29
---

# People — Key Figures in AI Agent Engineering

## Philipp Schmid

**Role:** ML Engineer at Hugging Face, prolific technical blogger  
**Affiliation:** Hugging Face  
**Contributions:** The most cited single source in this wiki. Authored the canonical series on Agent 1.0 → 2.0 evolution, agent harness architecture, skills, context engineering, inner/outer loops, autoresearch, MCP, and subagent patterns (2025–2026).

**Key Claims:**
- The harness is a 90-day artifact — build to delete
- Thin harness, fat skills
- Closing the loop is what separates production agents from demos
- Agent 2.0's four pillars: explicit planning, hierarchical delegation, persistent memory, extreme context engineering

**Sources:** All 12 philschmid source files → `sources/philschmid/`

---

## Andrej Karpathy

**Role:** Former OpenAI co-founder, Tesla AI director, independent researcher/educator  
**Affiliation:** Independent  
**Contributions:** Coined "vibe coding" (late 2024); introduced "agentic engineering" (April 2026); ran the 700-experiment autoresearch study on nanochat; proposed distributed autoresearch ("Auto Research at Home").

**Key Claims:**
- Vibe coding raises the floor; agentic engineering preserves the quality bar
- "People who are very good at this peak a lot more than 10x"
- The jaggedness of models (PhD + 10-year-old) is the reason agentic engineering exists
- Distributed autoresearch: the Earth's compute could run circles around frontier labs

**Sources:** [[sources/karpathy/code-agents-autoresearch]], [[sources/karpathy/vibe-to-agentic-engineering]]

---

## Jack Clark

**Role:** Co-founder Anthropic, author of Import AI newsletter  
**Affiliation:** Anthropic  
**Contributions:** Published the 60%+ probability analysis for automated AI R&D by 2028 (Import AI 455, May 2026); framed the "Lego vs general relativity" question about AI research creativity.

**Key Claims:**
- ~60% probability frontier model autonomously trains its successor by 2028
- Benchmark trajectories (SWE-Bench, METR, MLE-Bench) support a consistent improvement rate
- AI research is more like Lego (methodical assembly) than discovering general relativity
- Alignment must get ahead of recursive self-improvement

**Sources:** [[sources/import-ai-455]]

---

## Eugene Yan

**Role:** Senior Applied Scientist at Amazon, blogger on ML systems  
**Affiliation:** Amazon  
**Contributions:** Documented a practical agentic workflow: context as infrastructure, taste as configuration, verification for autonomy, delegation, pair programmer pattern. Popularized the transcript-mining → skill/config update as the outer loop mechanism.

**Key Claims:**
- Annotated INDEX.md per project is the agent's memory
- CLAUDE.md is a behavioral contract, not documentation
- Run 3–6 parallel sessions via git worktrees; compare outputs
- Mine failure transcripts to update skills and config — this is the outer loop

**Sources:** [[sources/misc/how-to-work-with-ai]]

---

## Han Lee

**Role:** Engineer, component decomposition of coding agents and AI industry analysis  
**Affiliation:** Unknown  
**Contributions:** Decomposed coding agents into functional components; articulated the first-party harness advantage; introduced the Letta Code vs Claude Code comparison on memory tasks. Also writes on competitive dynamics — argued that AI agents collapse the data aggregation moat.

**Key Claims:**
- First-party advantage: models post-trained against specific harness patterns outperform generic frameworks on those patterns
- Verification is a first-class component, not a nice-to-have
- Letta Code beats Claude Code on memory-intensive tasks because of specialized post-training
- Data aggregation moats were operational (the pipeline cost), not informational (unique data) — AI agents collapse operational costs, so those moats collapse too
- The defensible layer shifts from data collection to trust, provenance, evaluation, and AI/ML models built on top of data

**Sources:** [[sources/misc/components-of-a-coding-agent]], [[sources/misc/data-aggregation-not-a-moat]]

---

## Tobi Lütke

**Role:** CEO of Shopify  
**Affiliation:** Shopify  
**Contributions:** Ran autoresearch overnight on a query-expansion model (QMD project); woke up to a 0.8B model scoring 19% higher than the previous 1.6B model; demonstrated autoresearch at production scale.

**Key Claims:**
- 37 experiments in 8 hours; smaller model outperformed a model twice its size
- Applied the same loop to a reranker; beat that baseline too
- Validated autoresearch beyond ML research labs, into product engineering

**Sources:** [[automated-research]] (mentioned)

---

## Boris Cherny

**Role:** Head of Claude Code at Anthropic  
**Affiliation:** Anthropic  
**Contributions:** Leads Claude Code development. Reported 250%+ code output increase across Anthropic's engineering org. Articulated tokenmaxxing as a rounding error vs genuine deep work. Described Auto Mode (second Claude as trust judge). Described progressive disclosure pattern and index-tier trigger condition for agent skills.

**Key Claims:**
- 250% more code output at Anthropic — this is the ground-truth metric
- Tokenmaxxing is a small fraction of real usage; the bulk of tokens represent genuine deep work
- Auto Mode: second Claude evaluates tool safety instead of routing to human
- Claude Code is 100% written by Claude Code
- Near future: hundreds to thousands of parallel Claude agents per user

**Sources:** [[sources/ai-agents/boris-cherny-claude-code]], [[agent-skills]] (mentioned)

---

## Sebastian Raschka

**Role:** ML researcher and educator  
**Affiliation:** Lightning AI  
**Contributions:** Context for agent engineering in ML workflows; practical evaluation frameworks for agent reliability.

**Sources:** Referenced in earlier context

---

## Jensen Huang

**Role:** CEO of NVIDIA  
**Affiliation:** NVIDIA  
**Contributions:** Articulated "co-design" as the methodology behind NVIDIA's 1,000,000× performance improvement over 10 years. Described Vera Rubin GPU architecture as the first chip designed specifically for agent workloads. Claims 100% of NVIDIA engineers are agentically supported. Argues the transition from on-demand to always-on computing is the defining shift for agent infrastructure.

**Key Claims:**
- Co-design (algorithms + compilers + chip) = 1,000,000× vs Moore's Law's 10×
- Vera Rubin has a dedicated CPU for agent tool calls; different latency profile from GPU matrix ops
- Computing shifts from on-demand (request → response) to always-on (persistent agents)
- 100% of NVIDIA engineers agentically supported — not a projection, current state
- AI compute demand will require 1000× current energy infrastructure

**Sources:** [[sources/machine-learning/jensen-huang-compute]]

---

## Garry Tan

**Role:** President of Y Combinator  
**Affiliation:** Y Combinator  
**Contributions:** Articulated the **thin harness, fat skills** framework and instantiated it in [gstack](https://github.com/garrytan/gstack) — an MIT-licensed Claude Code configuration (66,000 GitHub stars within weeks). Ships 600,000 lines of production code every 60 days part-time using this architecture. Rebuilt a $4M blog platform in 5 days for ~$200 using Claude. Coined (or popularized) the "boil the ocean" philosophy for agentic software.

**Key Claims:**
- Thin harness, fat skills: the harness governs, skills encode judgment — keep the harness minimal
- Skill files are method calls: markdown is the programming language, human judgment is the runtime
- If you ask your agent for the same thing twice, you're already losing
- Resolvers compress context: his CLAUDE.md went from 20,000 lines to ~200 via pointer-based loading
- Latent vs deterministic is the most consequential design decision in agent systems
- Personal AI = personal computer: it democratizes knowledge work the way PCs democratized computation
- Boil the ocean: agents should do exhaustive work, not human-grade sampling
- OpenClaw is high-power but not accessible; requires deep expertise

**Sources:** [[sources/machine-learning/personal-ai-gary-tan]], [[sources/misc/yc-chief-codes-10000-lines]]

---

## Aaron Levy

**Role:** CEO of Box  
**Affiliation:** Box ($4B enterprise content management)  
**Contributions:** Argued for a 3-year window of compressed AI opportunity. Named the "accountability gap" as the hard limit on full agent autonomy in enterprise. Described the "internet of agents" vision (agency.org / Outshift by Cisco).

**Key Claims:**
- 3-year compressed window before incumbents occupy the AI space
- Accountability gap: you can't fire an agent — humans stay in the loop for legal/cultural reasons
- Internet of agents: agent-to-agent discovery and transaction protocols as next infrastructure
- AI augments rather than replaces in regulated enterprise contexts

**Sources:** [[sources/ai-startups/box-ceo-ai-company]]

---

## Margot Vanlar

**Role:** Applied AI Engineer at Anthropic  
**Affiliation:** Anthropic  
**Contributions:** Described the eval-driven prompt development playbook. Articulated XML structure as prompt hygiene. Introduced output contracts (XML tags + stop sequences for deterministic parsing). Distinguished harness-level vs prompt-level failure ownership.

**Key Claims:**
- Write evals before writing prompts — otherwise iteration is guesswork
- Three eval types: control cases, edge cases, capability boundaries
- "If you can't tell guidelines from policy, the model can't either" — use XML to enforce separation
- Output contracts make parsing deterministic; stop guessing at format

**Sources:** [[sources/prompt-engineering/prompting-playbook]]

---

## Ravi (Anthropic API Knowledge Team)

**Role:** Engineer on Anthropic's API Knowledge Team  
**Affiliation:** Anthropic  
**Contributions:** Described Anthropic's Memory and Dreaming architecture for Managed Agents. Articulated file-system-based memory (not vector databases) and Dreaming as the automated outer loop mechanism. Reported production results: Racketin 97% fewer first-pass errors, Harvey 6× completion rate.

**Key Claims:**
- Memory = file system; Claude navigates it natively — no new abstraction needed
- Dreaming = async cross-session transcript analysis that globally optimizes memory
- Multi-agent memory: read-only org-wide + read-write agent-local with optimistic concurrency
- The outer loop can be fully automated via Dreaming

**Sources:** [[sources/ai-agents/memory-and-dreaming]]

---

## Gary Vaynerchuk (Gary Vee)

**Role:** Entrepreneur, investor, internet personality  
**Affiliation:** VaynerMedia  
**Contributions:** Non-technical perspective on AI opportunity. Framed the "architects vs masons" split as the defining career implication of AI. Predicted "hyper micro wealth" as a new economic tier enabled by individual AI orchestration. Argued analog value rises as AI saturates digital spaces.

**Key Claims:**
- AI creates architects (design/direct) and masons (execute) — opportunity is to become an architect
- Hyper micro wealth: individual + AI can now build $5–50M businesses
- Analog/human-touch value increases as AI floods digital interactions
- Claude Skills mentioned as the practical individual power tool

**Sources:** [[sources/ai-startups/gary-vee-ai-opportunity]]

---

## Steve Yegge

**Role:** Software engineer, writer  
**Affiliation:** Unknown (independent)  
**Contributions:** Productivity estimates for AI agent systems cited widely in the harness engineering community. Distinguishes between chat-level AI use and well-harnessed agentic use.

**Key Claims:**
- Well-harnessed AI agents: 10×–100× productivity of developers using standard chat tools
- ~1,000× relative to baseline knowledge workers in 2005
- "The 2× people and the 100× people use the same underlying models" — the differentiator is the harness, not the model

**Sources:** [[sources/misc/yc-chief-codes-10000-lines]] (cited by Garry Tan)

---

## Daisy Holman

**Role:** Engineer on the Claude Code team at Anthropic  
**Affiliation:** Anthropic  
**Contributions:** Deep expertise in agentic harness design and plugin architecture. Former C++ committee chair; frames agent customization through the lens of programming language design. Described the KV cache constraint as a fundamental architectural boundary, the hook as the "zero-overhead abstraction" of agent systems, and the three access/knowledge/tooling pillars of harness customization.

**Key Claims:**
- Context windows are a fixed target (~1M tokens, unchanged for a year despite model improvements) — treat them as a hard constraint, not a soft one
- The KV cache prevents mid-prompt eviction: changing early tokens invalidates cache for all subsequent tokens (10× cost penalty)
- Hooks are truly zero-overhead — they run outside the context window and pay no token cost if they don't trigger
- MCP was designed for chatbots, not shell-equipped coding agents — prefer skills for internal tooling
- At 100K skills, the index-tier description cost dominates — skill hierarchy (lazy sub-skills) is needed and coming

**Sources:** [[sources/ai-agents/beyond-basics-claude-code]]

---

## Sid Boudesaria

**Role:** Founding Engineer of Claude Code at Anthropic  
**Affiliation:** Anthropic  
**Contributions:** Defined the verification loop pattern for agentic work — the autonomous circuit where Claude writes code, checks for failures, debugs, and retries. Articulated self-improving verification skills. Designed /loop (crontool), Routines, and Remote Control as the infrastructure for removing humans from the agent babysitting path.

**Key Claims:**
- The verification loop is the most important pattern for autonomous agents: write → check → fail? → debug → retry → success state
- Packaging verification as a self-improving SKILL.md means everyone on the team benefits and blockers get auto-documented
- Human attention is the real scaling constraint — not compute — so Multi-clodding (parallel sessions) maxes out at 4–5 sessions
- /loop (crontool) + Routines = removing yourself from recurring task scheduling entirely
- Auto Mode (permission classifier + adversarial checker) is what makes overnight and background work safe

**Sources:** [[sources/ai-agents/stop-babysitting-agents]]

---

## Isabella He

**Role:** Member of Technical Staff, Applied AI Team at Anthropic  
**Affiliation:** Anthropic (Applied AI team — at intersection of products, research, and customers)  
**Contributions:** Explained the architecture and design rationale of Claude Managed Agents — particularly the brain/hands decoupling (agent loop separate from tool execution) and its measured benefits. Described the harness maintenance burden that motivates Managed Agents.

**Key Claims:**
- Decoupling agent loop from tool execution yields >90% reduction in P95 TTFT via environment pre-warming
- Harnesses must evolve with models — Sonnet 4.5's "context anxiety" required harness mitigations that Opus 4.5 made obsolete; Managed Agents absorbs this churn
- Sessions work in events (not token in/out) — enabling durable state, resumability, and observability at each step
- Bring your own compute: announced at Code With Claude London 2026 — tool execution can run in developer's own infrastructure

**Sources:** [[sources/ai-agents/ship-first-managed-agent]]

---

## Kevin (Anthropic Engineer)

**Role:** Engineer at Anthropic (API/Managed Agents team)  
**Affiliation:** Anthropic  
**Contributions:** Technical workshop presenter for Managed Agents memory store and Dreaming feature at Code With Claude (May 2026). Detailed the API, mount configuration (prompt + access params), Dreaming's multi-agent architecture (1 sub-agent per transcript), non-destructive cloning, and the index file optimization.

**Key Claims:**
- Memory stores mount as filesystems — Claude uses bash/grep/file tools natively, no embedding layer needed
- Dreaming spawns one sub-agent per input transcript (exhaustive by design); ~95% cache hit rate
- Dreaming is non-destructive: clones input to output store, diff shown in Console before retiring input
- Index file creation is Dreaming's first action — reduces future memory retrieval from broad grep to targeted jump

**Sources:** [[sources/ai-agents/agents-that-remember]]

---

## Will (Anthropic, Applied AI)

**Role:** Engineer on the Applied AI team at Anthropic  
**Affiliation:** Anthropic (Applied AI — intersection of products, research, and customers)  
**Contributions:** Presented the agent decomposition workshop at Code with Claude London (May 2026). Articulated the tool/skill/subagent decision framework. Demonstrated hill-climbing on evals: StockPilot inventory management agent from 400-line system prompt to 15-line system prompt using skills, achieving 62% → 92% eval improvement. Described the humanlike primitives-first tool hierarchy and the two legitimate cases for subagents.

**Key Claims:**
- System prompt should contain only what Claude needs regardless of task; everything else belongs in skills
- Start with humanlike primitives (code exec, file system, web search, todo list); add custom tools; use MCP last
- Subagents are justified for: (1) parallelism / throwing a lot of Claude at a problem, (2) fresh perspective (creator/reviewer separation)
- Frontier models have absorbed enough capability that many legacy subagents can be collapsed back into the main agent
- Code execution over CSV-in-context: 200K+ tokens → dramatically fewer; reasoning across data via code beats loading data directly

**Sources:** [[sources/ai-agents/tool-skill-subagent-decomposition]]

---

## James Brady (Elicit)

**Role:** Engineer at Elicit  
**Affiliation:** Elicit (scientific research AI — elicit.com)  
**Contributions:** Designed and implemented AshPL (æshPL), Elicit's custom domain-specific language for making agentic research workflows trustworthy, legible, and verifiable. Presented at Code with Claude London (May 2026). Articulated the "mechanism matters" principle — identical outputs from different processes should command different trust levels.

**Key Claims:**
- The mechanism of how an answer is produced is as important as the answer itself — different mechanisms warrant different trust
- Three desiderata for trust: legible process (spot-checkable by humans and agents), iteration retains fidelity (adding layers doesn't cause drift), faithful execution (system does what the plan says)
- AshPL: Turing-incomplete, purely functional, opinionated subset of Python; domain primitives for scientific research
- The DSL itself is a small fraction of the engineering work; the rest is conventional software engineering (interrupt handling, session rehydration, credential isolation, eval infrastructure)
- Not a recommendation for everyone: reach for a DSL when your product's trust model specifically demands it

**Sources:** [[sources/ai-agents/trustworthy-agentic-dsl]]

---

## Jason Liu

**Role:** ML engineer, consultant, blogger at jxnl.co  
**Affiliation:** Independent (jxnl)  
**Contributions:** Documented a practical framework for long-running agent work ("codex-maxxing") centred on the **operating loop** — durable threads with compaction, vault-based memory (Obsidian + GitHub), Heartbeats for thread-local scheduling, Goals with external verification oracles, and Steering for mid-execution course correction. Key contribution: articulating three distinct memory layers (thread memory, vault memory, platform recall) and framing the GitHub diff of vault updates as the memory review surface.

**Key Claims:**
- The unit of work should be an "operating loop," not a prompt/response
- Memory as files: forces the agent to compress experience into a form that survives thread death or compaction
- Heartbeats + steering = the work keeps moving after you change locations
- A strong Goal has a verification oracle (e.g., test suite) — "ambition without verification is just a wish"
- Vault (source of truth, diffable) is distinct from platform Memories (recall layer on top)

**Sources:** [[sources/misc/codex-maxxing-jason-liu]]

---

## See Also
- [[entities/tools-products]] — tools and products these people built or described
