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

{{< callout type="warning" >}}
This implementation assumes that the transferred information can be interpreted vice-versa.
{{< /callout >}}

We assume that that the interaction information behind the generic parameter `I` has the same type
and interpretation for both interaction variants.
For example, the [`MiePotential`](/docs/cellular_raza_building_blocks/struct.MiePotential.html)
and the [`MorsePotential`](/docs/cellular_raza_building_blocks/struct.MorsePotential.html)
both exchange the radius variable and are thus compatible with each other.
If one of those types would exchange the diameter instead of the radius, the implementation would
still work but the interpretation of the exchanged information would not be identical and thus wrong
results would be calculated.

### Differing Information

In this section we will deal with two interaction types that have different information types
`I1, I2`.

{{< codeFromFile
    file="cellular_raza/cellular_raza-examples/homepage-training/src/building_blocks/switching.rs"
    filename="cellular_raza-examples/homepage-training/src/building_blocks/switching.rs"
    start="49"
    end="99"
>}}

{{< callout type="warning" >}}
We assume here that we pick one of the two variants in the beginning and thus initialize all agents
with this variant.
In the case where multiple variants can be chosen simultaneously, we would have to specify the two
conditions

{{< details title="Sketched Implementation" closed="true" >}}

```rust
fn calculate_force_between(
    ...,
) -> Result<(T, T), CalcError> {
    use SphericalInteraction::*;
    match (self, ext_info) {
        // See as above
        ... ,
        // Also implement functionality here
        (BLJ(pot), IInf::Morse(inf)) => ...,
        (Morse(pot), IInf::BLJ(inf)) => ...,
    }
}
```

{{< /details >}}
{{< /callout >}}

### Differing Position, Velocity, Force

We assume that the [position](/internals/concepts/cell/position),
[velocity](/internals/concepts/cell/velocity) and
[force](/internals/concepts/cell/interaction) types are distinct but shared between the different
interaction types.

{{< codeFromFile
    file="cellular_raza/cellular_raza-examples/homepage-training/src/building_blocks/switching.rs"
    filename="cellular_raza-examples/homepage-training/src/building_blocks/switching.rs"
    start="138"
    end="199"
>}}

In the case where each interaction potential has its own
[position](/internals/concepts/cell/position), [velocity](/internals/concepts/cell/velocity) or
[force](/internals/concepts/cell/interaction) type, we need to also construct enums for position
`enum PPos<P1, P2, ..> {..}` just as we did for the interaction information `IInf<I1, I2, ..> {..}`.
Additionally, we will now have to also implement the
[`Xapy`](/docs/cellular_raza_core/backend/chili/trait.Xapy.html) trait for these types in order to
be able to numerically use them.
We do not in general recommend this approach and would advise to consider to try in using distinct
information types instead.

{{< callout type="warning" >}}
The same warning about mixing variants as in the previous section applies here.
{{< /callout >}}
