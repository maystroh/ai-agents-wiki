---
title: Evals & Graders for Agentic Systems
tags:
  - evals
  - quality
  - agent-engineering
  - graders
  - hill-climbing
sources:
  - evals-for-taste
  - tool-skill-subagent-decomposition
  - testing-skills
updated: 2026-05-28
---

# Evals & Graders for Agentic Systems

## Definition

**Evals** are systematic tests that measure how well an AI system performs on a specific domain or use case. They give you actionable information about quality, what the system does well, what it fails on, and how changes affect performance over time.

Evals are distinct from *vibes* — intuitive impressions that something works or feels worse today. Vibes are useful as a general sanity check; evals are what you act on.

> [!important] Build your own evals
> Public benchmarks (SWE-bench, TerminalBench, ARC-AGI) measure generic capabilities. They rarely capture your specific use case. Custom evals on your domain are the only way to know if your agent is actually behaving as intended.

## Why Evals Matter

Without evals you are in a **reactive loop**: waiting for production feedback, debugging manually, flying blind. The specific costs:

- Catch issues only in production
- One fix creates downstream regressions you didn't test for
- Can't distinguish genuine feedback from noise
- No way to verify whether a change actually improved the system

With evals you gain **clarity**: define success explicitly, iterate on agent configs empirically, adopt new models with objective comparison data, and catch regressions before launch.

**Forcing function:** Writing evals forces you to articulate what success looks like. If you can't write an eval for a behavior, you haven't defined it precisely enough to build it.

## Three Types of Graders

| Type | How it works | Pros | Cons | Best for |
|---|---|---|---|---|
| **Code-based** | String match, regex, count, compile check, fuzzy match | Fast, cheap, deterministic | Brittle, lacks nuance | Counts, structure checks, tool call verification, format compliance |
| **Model-based (LLM judge)** | Rubric-prompted LLM scores on 0–N scale; pairwise comparison; multi-judge consensus | Flexible, scalable, nuanced | Nondeterministic, costly, requires calibration | Quality dimensions that can't be counted (layout, tone, coherence, style) |
| **Human** | Subject matter expert review, AB testing, spot checks | Highest quality, most nuanced | Slow, expensive | Calibrating model graders; final quality bar; resolving ambiguous eval saturation |

**Mix types:** Use code graders for anything countable; model graders for judgment calls; human graders to calibrate model graders and do periodic spot checks.

## Code-Based Graders

Code graders are the equivalent of unit tests in software engineering. They are:
- **String match / regex** — specific text must be present or absent
- **Count checks** — number of slides, number of emojis, number of tool calls
- **File existence checks** — did the agent produce the expected output file?
- **Structure validation** — correct JSON shape, required fields present
- **Compile/parse checks** — code the agent wrote actually runs

**Trade-off:** Code graders force deterministic behavior, which is sometimes exactly what you want and sometimes inappropriately constrains the agent.

## Model-Based Graders (LLM-as-Judge)

### Score-After-Reasons (Critical Calibration Pattern)

The most common LLM judge anti-pattern: ask for a score first, then ask why.

Because LLMs are autoregressive, once they output a score they post-hoc rationalize it — even a clearly wrong score will be defended with invented reasons. This produces scores that are consistent but uncalibrated.

**Correct pattern:**
1. Ask for pros, cons, reasons — in either direction
2. Ask the model to synthesize a final score *based on* those reasons

This lets the model reason its way *to* a score rather than anchor and rationalize.

### Pairwise Comparison

Instead of absolute scoring, ask: "Which of these two outputs do you prefer, and why?" Pairwise comparison sidesteps the calibration problem when you don't have a stable sense of what a 3/5 vs 4/5 means — relative judgments are more reliable than absolute ones.

### Multi-Judge Consensus

Run N independent judges on the same output; take majority vote. Reduces variance from any single nondeterministic judge run. Tradeoff: N× cost. Useful when consistency matters more than speed.

### Anchoring Judges

If you do use absolute scores, give the judge **anchor examples**: "A score of 1 means the output has these specific problems. A score of 5 means these specific qualities." Without anchors, model judges have no reference point and produce inconsistent scales.

## The Hill-Climbing Workflow

```
run eval suite
    ↓
inspect failures (which graders fail? why?)
    ↓
form hypotheses about root causes
    ↓
change one thing: system prompt / model / tools / QA loop
    ↓
rerun evals
    ↓
check for regressions (did fixing A break B?)
    ↓
repeat
```

**Why hill-climbing?** Each eval run gives you a score. Architectural and prompt changes should move that score up. If they don't, you've learned the change didn't actually address the failure mode.

**StockPilot example:** Eval score started at 83%, dropped to 62% on a rerun with the same architecture. After architectural modernization (skills, primitive tools, managed subagent), climbed to 92%.

**Slide agent example:** Minimal prompt → emoji-heavy, cluttered output. Added typography constraints → reduced clutter, new emoji artifacts. Added diagram requirement → cleaner, data-grounded. Added QA loop → measurably higher judge scores across all dimensions.

## QA Loop Pattern

A universally applicable upgrade: add a **creator + adversarial critic** structure.

- **Creator** builds the artifact
- **Critic** is explicitly told: "Assume there are problems. Approach QA as a bug hunt, not a confirmation step. Find them."
- **Creator** revises based on critique
- Loop continues until critic is satisfied (or N iterations)

The key is adversarial framing — a critic told "check if there are issues" will confirm-bias toward "looks fine." A critic told "there are issues; find them" will actually find them.

**Variant:** Multi-agent critique where one agent identifies issues and a second refutes them, with a third synthesizing — useful for domains like legal analysis where overclaiming and hedging are both failure modes.

## Eval Saturation

An eval is **saturated** when it no longer provides useful signal. This happens when:
- The system consistently maxes out a judge's score
- The judge's rubric is too vague to distinguish good from excellent
- The feature the eval was testing has been fully solved

Saturated evals should be updated or retired rather than kept as false confidence signals. A saturated eval that seems to pass while the underlying quality has regressed (or that the model "game" without improving real quality) is worse than no eval.

## Evals for Model Selection

With evals, model selection becomes empirical rather than anecdotal:

- Run new model on your eval suite
- Compare against current model on the specific dimensions you care about
- Accept the new model where it wins, stick with current where it loses
- Catch regressions before they reach users

Evals make it possible to continuously evaluate each new model release against your use case rather than making global decisions based on benchmark leaderboards.

## Skill Evals

For [[agent-skills]] specifically:

- **Trigger tests:** Does the skill load when it should? (should-trigger prompts)
- **Non-trigger tests:** Does it *not* load when it shouldn't? (over-triggering)
- **Output tests:** Given the skill is loaded, does it produce correct behavior?
- **Negative tests:** Does adding the skill regress any non-targeted behavior?

Run 3–5 trials per prompt — agent output is nondeterministic. Isolation between runs prevents context bleeding from masking real failures.

See [[agent-skills]] for the SkillsBench finding: most deployed skills are never properly evaled and most AI-generated skills provide no benefit on average.

## Tensions & Tradeoffs

**Speed vs rigor:** Code graders are fast and cheap but brittle. Model graders are nuanced but slow and costly. The right mix depends on your reliability requirements and evaluation budget.

**Calibration cost:** Model judges require ongoing calibration via human review. This is an ongoing cost, not a one-time setup.

**Eval gaming:** Optimizing specifically for an eval (as opposed to the underlying quality it measures) produces Goodhart's Law failures — the eval passes while the real problem persists. Rotating evals, adding new ones, and human spot-checks counter this.

**Determinism as constraint:** Code graders are deterministic, but agent outputs aren't. Testing nondeterministic output with deterministic checks requires either multiple trial runs or wider acceptance criteria.

## Related Concepts

- [[agent-skills]] — skill eval harness; trigger/non-trigger tests; retirement pattern
- [[agent-engineering]] — evals as the operational instrument for probabilistic systems
- [[closing-the-loop]] — QA loops and verification as a form of in-task eval
- [[agent-harness]] — where eval hooks live in the harness architecture
