---
title: 🌊 Reactions
weight: 30
---

The [`SubDomainReactions`](/docs/cellular_raza_concepts/trait.SubDomainReactions.html) trait can
model how extracellular resources are transported and how the domain interacts with cells (eg. via
secretion and uptake).
The `get_neighbor_value` and `get_border_info` methods allow multiple subdomains to communicate
properly and resolve update steps between them.
The `get_extracellular_at_pos` method allows cells to query for extracellular values at their
position in order to calculate their increments.
Afterwards, `treat_increments` function is used for handling of these and other contributions.
Finally, the `update_fluid_dynamics` method advances the simulation of extracellular reactions.

Currently we are still missing fully working building blocks for `SubDomainReactions` but are in the
midst of adding them.
The [Bacterial Branching](/showcase/bacterial-branching) showcase is in the middle of being
rewritten with the newer [chili](/internals/backends/chili) backend which will use this aspect.
