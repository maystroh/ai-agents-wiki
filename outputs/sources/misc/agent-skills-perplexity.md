---
title: "Designing, Refining, and Maintaining Agent Skills at Perplexity"
author: Perplexity Team
date: 2025
tags:
  - misc
  - skills
  - production
  - case-study
---

# Designing, Refining, and Maintaining Agent Skills at Perplexity

## Summary

- Case study on how Perplexity designs and maintains skills for their Perplexity Computer agent
- Skills are used for web browsing, code execution, and information retrieval — each as a distinct skill with scoped tool access
- Covers the skill lifecycle: design → test → deploy → monitor → refine
- Monitoring approach: track skill trigger rates and task success rates to identify skills that fire too often, too rarely, or correlate with failures

## Key Insights

- **Trigger rate is a leading indicator of skill quality.** A skill that fires on <5% of tasks may have an under-specified description. A skill that fires on >40% may be too broad.
- **Skills at Perplexity scope tool access, not just behavior.** The web browsing skill has access to browser tools; the code skill has access to the code interpreter. This is least-privilege at the skill level.
- **Refinement is continuous.** Skills are never "done." Perplexity reviews skill performance weekly and updates descriptions and bodies based on failure transcripts.
- **The skill index is a UX artifact.** When a user asks "what can this agent do?", the skill index *is* the answer. Write descriptions for users, not just for the model.

## Concepts Touched

- [[agent-skills]] — full skill architecture
- [[inner-outer-loop]] — skill refinement as outer loop
- [[mcp-servers]] — tool scoping at the skill level

## Notable Quotes

> "Trigger rate is a leading indicator of skill quality. A skill that never fires is a dead skill — but a skill that always fires is a context tax."
