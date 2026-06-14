---
title: Inner Loop vs Outer Loop
tags:
  - core-concept
  - loops
  - memory
  - reliability
aliases:
  - Agent Loops
  - Closing the Loop
sources:
  - inner-outer-loop
  - closing-the-loop
  - how-to-work-with-ai
  - codex-maxxing-jason-liu
updated: 2026-05-29
---

# Inner Loop vs Outer Loop

## The Loop is Hardcoded

Every agent framework runs the same cycle:

```
model generates → if tool call: execute → feed result back → model generates → repeat
```

This scaffolding is identical for every agent. **What differs is what the model chooses to do inside the loop.**

## The Inner Loop — Verification Within a Task

The inner loop is what happens during a single task, before the agent responds to the user. It's the tight feedback cycle between the model and its tools.

> [!example] Weak vs strong agent
> **Weak agent:** Edits a file and says "Done!"
> 
> **Strong agent:** Edits file → writes tests → runs tests → reads error → fixes edge case → runs again → sees green → then responds.
> 
> Same infrastructure. Different behavior.

The agent that closes its inner loop doesn't need special infrastructure — it makes better decisions about *when* to verify before saying it's done.

**Where does the verification behavior come from?**
1. **System prompt** — "Always run tests after code changes" (explicit instruction)
2. **Post-training / RL** — test pass/fail as a reward signal, so the model internalizes the verify step
3. **Spontaneous verification** (emerging) — DeepMind research showed a model checking its own plan step-by-step against task rules boosted planning success from 50% → 89%

### Production Loop-Closing: Spotify's Approach
After 1,500+ agent-generated PRs, Spotify built independent verifiers (Maven builds, test runners, formatters) exposed as a single MCP tool. The agent calls "verify" and gets pass/fail. An additional LLM judge compares the final diff against the original prompt — catching scope creep ("agents getting creative" and refactoring code nobody asked them to touch).

## The Outer Loop — Learning Across Sessions

The outer loop is what happens across multiple turns and sessions. The question: **did the agent learn anything from the last task?**

Without persistent memory, every session is a clean slate. The agent that failed on pagination yesterday fails on it again today.

```
Session 1: Agent fails → user corrects → fix happens in-context only
Session 2: Clean slate — same mistake again
```

Almost no agent does this natively. The outer loop requires persistent state that survives between sessions:

| Mechanism | Description |
|---|---|
| `AGENTS.md` | Manual persistent instructions the user writes for future sessions |
| Session handoff documents | Structured summaries an agent writes at end of session for the next |
| Auto-generated `SKILL.md` | Agent analyzes failures and creates skills so the next task doesn't repeat mistakes |
| Memory files | `~/.claude/` configuration, preferences, feedback captured from transcripts |
| Heartbeats | Thread-local recurring automations — the thread schedules itself on a cadence; see below |

> [!tip] Mining transcripts for config updates
> Have the model scan past session transcripts for patterns like "can you also...", "did you check...", "still wrong". These signal what the model should have done unprompted — update CLAUDE.md or skills accordingly. (Eugene Yan scanned ~2,500 of his past user turns this way.)

### Heartbeats: Thread-Local Outer Loop Scheduling

**Heartbeats** (OpenAI Codex) are a thread-native scheduling mechanism that differs from external cron jobs in three ways:

1. **Thread-local:** The schedule lives inside the thread, not as external infrastructure. The thread schedules itself.
2. **Dynamic cadence:** A heartbeat can adjust its interval based on state — checking every 30 minutes normally, then switching to every 1 minute when a specific event occurs.
3. **Multiple schedules + completion condition:** A single thread can have multiple heartbeats running in parallel, each running until a condition is met rather than indefinitely.

**Comparison to /loop (Claude Code):**

| | Heartbeats (Codex) | /loop (Claude Code) | Routines (Claude Code Web) |
|---|---|---|---|
| Scheduling | Thread-native, self-set | User-initiated, runs in local session | Remote, event or time triggers |
| Cadence | Dynamic (self-adjusting) | Fixed interval | Fixed time or event |
| Scope | Thread-local context | Local session | Remote container |

**Cross-tool feedback loops.** Because heartbeats execute within a thread that already has tool access, a single heartbeat can chain across multiple tool boundaries without re-initialization:
```
Heartbeat every 15 min:
  1. Read Slack thread for new comments
  2. Re-render animation via Remotion
  3. Upload via @computer (because MCP couldn't upload)
  4. Post revised render back to Slack, tag reviewer
```

This is what makes the outer loop powerful: the feedback cycle runs across tools, not just within one service.

**See:** [[sources/misc/codex-maxxing-jason-liu]] for detailed Heartbeat examples.

## Inner Loop = Reliability. Outer Loop = Improvement.

| | Inner Loop | Outer Loop |
|---|---|---|
| **Scope** | Within one task | Across tasks/sessions |
| **What changes** | Model's verification behavior | Persistent memory, skills, config |
| **Outcome** | Correct output before responding | Not repeating the same mistakes |
| **Status (2026)** | Improving — scaffolding + emerging spontaneous verification | Rare in production; still mostly manual |

## Self-Awareness as Prerequisite

For an agent to close its loops well, it needs **operational self-knowledge**:
- Knows its context window limits and how instructions shape behavior
- Understands its tools and picks the right one instead of hallucinating an API
- Has calibrated uncertainty — knows when to verify ("this regex is complex, I should test it")

This is not consciousness — it's functional meta-cognition that produces better decisions inside the existing loop.

## See Also
- [[closing-the-loop]] — deep dive on verification and self-awareness
- [[agent-skills]] — skills as the outer-loop memory mechanism
- [[automated-research]] — the ultimate outer loop: AI improving AI
- [[context-engineering]] — managing state within the inner loop
- [[agent-memory]] — memory architecture is the substrate the outer loop operates on; Dreaming automates the outer loop across sessions
