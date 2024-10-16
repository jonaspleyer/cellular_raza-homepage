---
title: 🔘 Cell
weight: 10
sidebar:
    open: true
---

| Aspect | Description | Depends on |
| --- | --- | --- |
| [`Position`](/internals/concepts/cell/mechanics) | Spatial representation of the cell | |
| [`Velocity`](/internals/concepts/cell/mechanics) | Spatial velocity of the cell | |
| [`Mechanics`](/internals/concepts/cell/mechanics) | Calculates the next increment from given force, velocity and position. | `Position` and `Velocity` |
| [`Interaction`](/internals/concepts/cell/interaction) | Calculates force acting between agents. Also reacts to neighbours. | `Position` and `Velocity` |
| [`Cycle`](/internals/concepts/cell/cycle) | Changes core properties of the cell. Responsible for cell-division and death. | |
| [`Intracellular`](/internals/concepts/cell/reactions) | Intracellular representation of the cell. | |
| [`Reactions`](/internals/concepts/cell/reactions) | Intracellular reactions | `Intracellular` |
| [`ReactionsExtra`](/internals/concepts/cell/reactions) | Couples intra- & extracellular reactions | `DomainReactions` |
| [`ReactionsContact`](/internals/concepts/cell/reactions) | Models reactions between cells purely by contact | `Position`, `Intracellular` |
