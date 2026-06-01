---
title: "Stanford CS153 Frontier Systems: Jensen Huang from NVIDIA on the Compute Behind Intelligence"
author: Jensen Huang (NVIDIA CEO)
date: 2026-05-15
url: https://www.youtube.com/watch?v=tsQB0n0YV3k
tags:
  - compute
  - hardware
  - agents
  - vera-rubin
  - co-design
  - nvidia
  - machine-learning
sources:
  - "Machine Learning/Stanford Online/2026-05-15"
updated: 2026-05-24
---

# Stanford CS153 Frontier Systems: Jensen Huang on the Compute Behind Intelligence

## Summary

- Jensen Huang (NVIDIA CEO) argues that "co-design" — simultaneously optimizing across algorithms, compilers, and chip architecture — has delivered 1,000,000× performance improvement over 10 years, vs Moore's Law's 10×
- Computing is shifting from on-demand (request → response) to continuously running, always-available compute for persistent agents
- Vera Rubin (NVIDIA's 2026 GPU architecture) is explicitly designed for agent workloads: dedicated low-latency CPU for tool calls, direct storage-to-GPU fabric for rapid memory access
- 100% of NVIDIA's engineers are now agentically supported — Huang calls this their most important productivity transformation
- Energy demand for AI compute: Huang projects 1000× current levels needed, calling for massive infrastructure investment

## Key Insights

- **Co-design is the 1,000,000× story.** Moore's Law delivered 10× over a decade. NVIDIA's approach — redesigning algorithms alongside compilers alongside chip architecture together — delivered 1,000,000×. The same principle applies to agent system design: optimize the whole stack, not layers in isolation.
- **Vera Rubin is the agent chip.** The architectural breakthrough in Vera Rubin is a dedicated low-latency CPU alongside the GPU. When an agent makes a tool call (file read, API call, bash command), that's CPU-bound work with latency requirements very different from matrix multiplication. Vera Rubin co-locates this workload. Direct storage-to-GPU fabric eliminates the memory bandwidth bottleneck for long-context agent operations.
- **Computing shifts from on-demand to always-on.** Traditional computing: request arrives, spin up compute, return result. Agent computing: persistent processes running continuously, monitoring, acting, reporting. This requires different infrastructure assumptions — always-on memory, interrupt-driven action, not request-response cycles.
- **NVIDIA as the validation proof.** 100% of NVIDIA engineers are agentically supported. Huang uses this as a concrete claim, not a projection. The organization at the frontier of AI hardware has already adopted agentic workflows at 100% penetration.
- **Energy is the bottleneck.** Huang's 1000× energy projection is not hyperbole — it's his argument for why energy infrastructure is now the critical constraint. AI compute is projected to demand energy at grid scale, making energy investment equivalent to semiconductor investment in strategic importance.
- **Open models for security.** Huang advocates for open-weight models in enterprise contexts, arguing that companies need to inspect and audit the models running in their infrastructure. Closed models create vendor dependency and security blind spots.

## Concepts Touched

- [[concepts/agent-runtime]] — Vera Rubin architecture for agent workloads, always-on compute model
- [[concepts/agent-harness]] — hardware as a layer of the agent harness
- [[concepts/agent-engineering]] — NVIDIA's 100% agentic support as organizational proof
- [[entities/tools-products]] — Vera Rubin chip entry

## Notable Quotes

> "Moore's Law gave us 10× over a decade. Co-design gave us 1,000,000×."

> "Vera Rubin has a dedicated CPU for agent tool calls. The latency profile of a tool call is completely different from matrix multiplication."

> "Computing is shifting from on-demand to always-on. Agents don't wait for requests — they run continuously."

> "100% of NVIDIA engineers are agentically supported. That's not a goal — it's where we are."

> "Energy is the new semiconductor. If you're not investing in energy infrastructure, you're not investing in AI."
