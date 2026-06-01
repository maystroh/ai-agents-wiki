---
title: "Agent Skills — Tips and Patterns"
author: Philipp Schmid
date: 2026-04-13
url: https://www.philschmid.de/agent-skills-tips
tags:
  - philschmid
  - skills
  - progressive-disclosure
  - architecture
---

# Agent Skills — Tips and Patterns

## Summary

- Practical tips for writing, organizing, and maintaining Agent Skills (SKILL.md files)
- Covers the three-tier cost structure: Index (~100 tokens always loaded), Load (~5k on trigger), Runtime (unbounded, conditional)
- Writing the description: specific trigger phrases, one sentence for what + one for when, avoid overlap with other skills
- Hierarchy patterns: personal > team > project; how skills compose and override
- Retiring pattern: deprecation notice in description prevents new triggers while existing references still work

## Key Insights

- **The description is a trigger condition, not documentation.** Write it like an `if` statement: "Load when the user asks to X or Y." Vague descriptions = unpredictable triggering.
- **One sentence for what, one for when.** "Does X. Use when Y." Everything else belongs in the body.
- **Skills compose.** A skill body can reference another skill with `@skill-name`. Use this to share common context across multiple skills without duplication.
- **Personal > Team > Project hierarchy.** Personal skills override team skills, which override project skills. Use this for user-specific behavioral overrides without forking team config.
- **The retirement pattern.** Update the description to say "DEPRECATED — use [[new-skill]] instead." This prevents new triggers while not breaking existing references in prompts.

## Concepts Touched

- [[agent-skills]] — the full architecture
- [[agent-harness]] — skills as the modular extension layer
- [[context-engineering]] — progressive disclosure as a context management strategy

## Notable Quotes

> "Write the description like an if statement. Vague descriptions create unpredictable triggering — and an unpredictably-loading skill is worse than no skill."
