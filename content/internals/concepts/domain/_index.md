---
title: 🌍 Domain
weight: 20
sidebar:
    open: true
math: true
---

The [`Domain`](/docs/cellular_raza_concepts/trait.Domain.html) is home to the [`Cell`](../cell).
It handles movement, restricts cells by enforcing boundary conditions and can interact with them.

## Locality

The underlying structure of each domain and all interactions of agents inside it is assumed to be
local.
This means that given some process at a particular time-point $(t_1,x_1)$ and another at
$(t_2, x_2)$ that these two events only interfere with each other if they are sufficiently close to
each other.
The exact meaning of "sufficiently close" will depend on the particular domain and process.
But this assumption allows us to partition the domain into multiple chunks of which not all interact
with each other.
This allows us to handle calculations of interactions very efficiently and leads to linear scaling
with increasing number of cells (see [benchmarks/sim-size](/benchmarks/2024-07-sim-size-scaling)).

| Aspect | Description | Depends on |
| --- | --- | --- |
| [`Domain`](/internals/concepts/domain/decomposition) | Representation of the physical simulation domain. | |
| [`Mechanics`](/internals/concepts/domain/mechanics) | Handles forces which the domain may exert on a cell.| `Domain` |
| [`DomainForce`](/internals/concepts/domain/force) | The domain can exert forces onto the cell. | `Domain`,`Mechanics` |
| [`Reactions`](/internals/concepts/domain/reactions) | Models interactions of cells with extracellular resources (eg. by uptake or secretion).| `Domain` |
