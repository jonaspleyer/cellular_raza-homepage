---
title: Building Blocks
weight: 30
cascade:
    type: docs
---

`cellular_raza` is designed such that researchers are flexible when it comes to designing new
models for their respective use-cases.
However it is often desirable to not start from scratch completely but rely on existing work and
extend its behaviour.
[`cellular_raza-building_blocks`](/docs/cellular_raza_building_blocks) provide components or
complete cellular agents to be used when constructing new behaviour.
To reuse these existing components, we provide the
[`CellAgent`](/docs/cellular_raza_concepts/derive.CellAgent.html) and
[`SubDomain`](/docs/cellular_raza_concepts/derive.SubDomain.html) derive macros.

## CellAgent
Let's assume that we want to define a new cell type which uses the existing
[`Brownian3D`](/docs/cellular_raza_building_blocks/struct.Brownian3D.html) mechanics aspect.
To define this new cell, we simply define a new struct which contains the existing mechanics.
Before the struct keyword we add the `#[derive(CellAgent)]` macro and specify that we want to
derive the `#[Mechanics]` aspect.

```rust
#[derive(CellAgent)]
struct MyCellType {
    #[Mechanics]
    mechanics: Brownian3D,
}
```

This macro will now generate code that implements the
[`Position`](/docs/cellular_raza_concepts/trait.Position.html),
[`Velocity`](/docs/cellular_raza_concepts/trait.Velocity.html) and
[`Mechanics`](/docs/cellular_raza_concepts/trait.Mechanics.html) traits.
To get a glimpse of what is going on under the hood, we look at the generated code of the
`Position` trait.

```rust
#[allow(non_upper_case_globals)]
const _: () = {
    #[automatically_derived]
    impl<__cr_private_Pos> Position<__cr_private_Pos> for MyCellType
    where
        Brownian3D: Position<__cr_private_Pos>,
    {
        #[inline]
        fn pos(&self) -> __cr_private_Pos {
            <Brownian3D as Position<__cr_private_Pos>>::pos(&self.mechanics)
        }
        #[inline]
        fn set_pos(&mut self, pos: &__cr_private_Pos) {
            <Brownian3D as Position<
                __cr_private_Pos,
            >>::set_pos(&mut self.mechanics, pos)
        }
    }
}
```

This is very convenient and we can combine multiple building blocks or specify our own new types.
Many of the already existing examples such as the [cell-sorting](/showcase/cell-sorting) example
uses this approach.

{{< codeFromFile
    file="cellular_raza/cellular_raza-examples/cell_sorting/src/main.rs"
    filename="cellular_raza-examples/cell_sorting/src/main.rs"
    start="103"
    end="109"
>}}

## Domain & SubDomain

We also provide the
[`Domain`](/docs/cellular_raza_concepts/derive.Domain.html) and
[`SubDomain`](/docs/cellular_raza_concepts/derive.SubDomain.html) macros to derive functionality
related to the simulation [domain](/internals/concepts/domain).
Often it is only necessary to redefine the
[`SortCells`](/docs/cellular_raza_concepts/trait.SortCells.html) and
[`SubDomainMechanics`](/docs/cellular_raza_concepts/trait.SubDomainMechanics.html) traits in order
to reuse an existing domain for a new cell-agent type.

In particular, most effort is often spent on the
[`DomainCreateSubDomains`](/docs/cellular_raza_concepts/trait.DomainCreateSubDomains.html) traits
which decomposes the domain.
Deriving these functionalities is thus greatly convenient.

These derive macros are both used is used in the [bacterial-rods](/showcase/bacterial-rods) example.

{{< codeFromFile
    file="cellular_raza/cellular_raza-building-blocks/src/cell_building_blocks/bacterial_rods.rs"
    filename="cellular_raza-building-blocks/src/cell_building_blocks/bacterial_rods.rs"
    start="286"
    end="292"
>}}

{{< codeFromFile
    file="cellular_raza/cellular_raza-building-blocks/src/cell_building_blocks/bacterial_rods.rs"
    filename="cellular_raza-building-blocks/src/cell_building_blocks/bacterial_rods.rs"
    start="349"
    end="355"
>}}

## Generics

All derive macros have designed with generics in mind and should work out-of-the box.
If you find any bugs please let us know.
For instance, the following example compiles and is part of our test-suite:

{{< codeFromFile
    file="cellular_raza/cellular_raza-concepts/tests/derive_cell_agent.rs"
    filename="cellular_raza-concepts/tests/derive_cell_agent.rs"
    start="138"
    end="173"
>}}
