---
title: Aspects & Concepts
type: docs
weight: 5
sidebar:
    open: true
---

`cellular_raza` is built up with minimal assumptions on the underlying cellular and environmental
structure of the problem.
In order to describe a wide variety of cellular systems, we need abstractions over the individual
processes such that a numerical integrator can integrate the system in question.

We divide these theoretical abstractions into two subcategories.
Simulation [aspects](#aspects) contain information about the actuality of the simulation while
[concepts](#concepts) contain all other required abstractions such as storage methods,
time-steppers, etc.
In principle, we consider [concepts](#concepts) to be a superset of [aspects](#aspects) and thus
use the name [concepts](#concepts) for the combination of both of them.

## Aspects

Simulation [aspectss](#aspects) can be thought of as mathematical abstractions.
In the future, we aim to provide a concise mathematical notation in order to describe them.

| Aspect | Description | Depends on |
| --- | --- | --- |
| **Cellular Agent** | | |
| [`Position`](/internals/concepts/cell/mechanics) | Spatial representation of the cell | |
| [`Velocity`](/internals/concepts/cell/mechanics) | Spatial velocity of the cell | |
| [`Mechanics`](/internals/concepts/cell/mechanics) | Calculates the next increment from given force, velocity and position. | `Position` and `Velocity` |
| [`Interaction`](/internals/concepts/cell/interaction) | Calculates force acting between agents. Also reacts to neighbours. | `Position` and `Velocity` |
| [`Cycle`](/internals/concepts/cell/cycle) | Changes core properties of the cell. Responsible for cell-division and death. | |
| [`Intracellular`](/internals/concepts/cell/reactions) | Intracellular representation of the cell. | |
| [`Reactions`](/internals/concepts/cell/reactions) | Intracellular reactions | `Intracellular` |
| [`ReactionsExtra`](/internals/concepts/cell/reactions) | Couples intra- & extracellular reactions | `DomainReactions` |
| [`ReactionsContact`](/internals/concepts/cell/reactions) | Models reactions between cells purely by contact | `Position`, `Intracellular` |
| **Simulation Domain** | | |
| [`Domain`](/internals/concepts/domain/) | Represents the physical simulation domain. | |
| [`DomainMechanics`](/internals/concepts/domain/mechanics) | Apply boundary conditions to agents. | `Position`, `Velocity` |
| [`DomainForce`](/internals/concepts/domain/mechanics) | Apply a spatially-dependent force onto the cell. | `Mechanics` |
| [`DomainReactions`](/internals/concepts/domain/reactions) | Calculate extracellular reactions and effects such as diffusion. | `ReactionsExtra` |
| **Other** | | |
| [`Controller`](/internals/concepts/controller) | Externally apply changes to the cells. | |

## Concepts

| Name | Description | Depends on |
|:---:| --- |
| | |
