---
title: Quickly Switch between Blocks
weight: 20
---

This guide explains how multiple building blocks, serving the same purpose can be used within one
Agent thus allowing to experiment and compare two approaches.
We will explain the procedures along the example of the
[Interaction](/docs/cellular_raza_concepts/trait.Interaction.html) concept.

Frequently switching between [building blocks](/docs/cellular_raza_building_blocks/) is often
necessary when evaluating which model fits well for the system at hand.
`cellular_raza` makes extensive use of compile-time generics for which it is important to know what
types we are dealing with.
This means that we are left with two fundamental differing options:

1. Preserve performance but restrict ourselves to a predefined set of blocks
2. Allow maximum Flexibility at the expense of computational overhead

## Select Set of Blocks
### Identical Signatures

For this example, we assume that all types for position, velocity and force are identical.
The type for exchanging interaction information may however be distinct.
This means that we can implement the
[Interaction](/docs/cellular_raza_concepts/trait.Interaction.html) trait by using 2 generic
parameters `<T, I>` and implementing `Interaction<T, T, T, I>`.

{{< codeFromFile
    file="cellular_raza/cellular_raza-examples/homepage-training/src/building_blocks/switching.rs"
    filename="cellular_raza-examples/homepage-training/src/building_blocks/switching.rs"
    start="1"
    end="8"
>}}

{{< codeFromFile
    file="cellular_raza/cellular_raza-examples/homepage-training/src/building_blocks/switching.rs"
    filename="cellular_raza-examples/homepage-training/src/building_blocks/switching.rs"
    start="10"
    end="47"
>}}

### Differing Information

{{< codeFromFile
    file="cellular_raza/cellular_raza-examples/homepage-training/src/building_blocks/switching.rs"
    filename="cellular_raza-examples/homepage-training/src/building_blocks/switching.rs"
    start="49"
    end="99"
>}}

{{< callout type="info" >}}
Typically it is not desirable to have different representations of
[position](/internals/concepts/cell/position), [velocity](/internals/concepts/cell/velocity) or
[force](/internals/concepts/cell/interaction).
However such an approach could also be realized if truly desired.
{{< /callout >}}

### Differing Position, Velocity, Force

In the case that either the [position](/internals/concepts/cell/position),
[velocity](/internals/concepts/cell/velocity) or
[force](/internals/concepts/cell/interaction).

{{< codeFromFile
    file="cellular_raza/cellular_raza-examples/homepage-training/src/building_blocks/switching.rs"
    filename="cellular_raza-examples/homepage-training/src/building_blocks/switching.rs"
    start="138"
    end="150"
>}}

{{< codeFromFile
    file="cellular_raza/cellular_raza-examples/homepage-training/src/building_blocks/switching.rs"
    filename="cellular_raza-examples/homepage-training/src/building_blocks/switching.rs"
    start="152"
    end="199"
>}}
