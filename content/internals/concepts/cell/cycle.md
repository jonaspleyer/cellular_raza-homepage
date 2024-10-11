---
title: 🔄 Cycle
weight: 40
---

The [`Cycle`](/docs/cellular_raza_concepts/trait.Cycle.html) trait models the cell-cycle of an
agent.
It can not only alter the intracellular properties via the `update_cycle` method but is also capable
of introducing a [`CycleEvent`](/docs/cellular_raza_concepts/enum.CycleEvent.html) for division,
death or removal through its return value.
The `divide` method is responsible for performing the instant action of dividing one cellular agent.
Any preceding operations such as changes in size or shape before this instant need to be modeled by
other methods such as `update_cycle`.
The `update_conditional_phased_death` method provides an easy way to perform a transition between
a state in which the cell is alive and one where the cell is removed.
This means in particular that the cell continues to be present as long as the
`update_conditional_phased_death` method returns `Ok(false)`.

`cellular_raza` does currently not provide any building blocks related to the `Cycle` concept.
This is due to the reason that changes in the cell-cycle often affect the whole cell and thus
require knowledge about its definition and internals.
For this reason, the `Cycle` trait will almost always be needed to be manually implemented.

## Examples

The following examples contain implementations of the `Cycle` trait

- [Bacterial Rods](/showcase/bacterial-rods)
- [Bacterial Branching](/showcase/bacterial-branching)
