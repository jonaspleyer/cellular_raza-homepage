---
title: 💊 Reactions
weight: 30
math: true
---

The [`Reactions`](/docs/cellular_raza_concepts/trait.Reactions.html) trait models intracellular
reactions for invididual cellular agents.
It uses a single method `calculate_intracellular_increment` to calculate the derivative for a given
cellular configuration.
In addition, the [`ReactionsExtra`](/docs/cellular_raza_concepts/trait.ReactionsExtra.html) can be
used to interact with the physical domain eg. to model uptake or secretion.
The [`ReactionsContact`](/docs/cellular_raza_concepts/trait.ReactionsContact.html) trait describes
reactions which can occur between cells which are in close proximity to each other and coupled eg.
via cell walls.

## Example: Autonomous ODEs

Autonomous Ordinary Differential Equations (ODEs) are typically represented by a state vector
$x\in\mathbb{R}^n$ of type `VectorN` and a function $f(x,p)$ together with initial conditions
$x_0\in\mathbb{R}^n$.

$$\begin{equation}
    \dot{x} = f(x,p)
\end{equation}$$

In our case, we can solve such a system by implementing the
[Reactions](/docs/cellular_raza_concepts/trait.Reactions.html) trait.

```rust
struct Cell {
    intracellular: VectorN,
}

impl Reactions<VectorN> for Cell {
    fn calculate_intracellular_increment(
        &sele,
        intracellular: &VectorN
    ) -> Result<VectorN, CalcError> {
        // Here we insert the functionality of f(x,p)
        Ok(...)
    }
}
```

## Remarks on Contact Reactions

Similarly to the [`Reactions`](/docs/cellular_raza_concepts/trait.Reactions.html) trait, we describe
changes to the intracellular state of cellular agents.
The `calculate_contact_increment` method is called for each neighboring cell as defined by the
domain-decomposition.

## More Examples

- [`cr_trichome`](/showcase/cr_trichome)
- [Bacterial Branching](/showcase/bacterial-branching)
