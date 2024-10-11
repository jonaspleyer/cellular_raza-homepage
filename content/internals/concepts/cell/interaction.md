---
title: 🎱 Interaction
weight: 20
---

The [`Interaction`](/docs/cellular_raza_concepts/trait.Interaction.html) trait is responsible for
modeling physical interactions between cellular agents.
It can also be used to detect and react to neighbors.

The `calculate_force_between` method calculates forces acting on the two cells in question which
will then later be used to update the position and velocity via the
[mechanics](/internals/concepts/cell/mechanics) concept.
We can also exchange information between the cells which is not related to their position or
velocity via the `get_interaction_information` method.

```rust
pub trait Interaction<Pos, Vel, Force, Inf = ()> {
    fn get_interaction_information(&self) -> Inf;

    fn calculate_force_between(
        &self,
        own_pos: &Pos,
        own_vel: &Vel,
        ext_pos: &Pos,
        ext_vel: &Vel,
        ext_info: &Inf
    ) -> Result<(Force, Force), CalcError>;
```

Furthermore, to model reactions to neighbors, the trait provides the `is_neighbor` and
`react_to_neighbors` methods which are used to first count the number of neighbors and then
react accordingly.

```rust
    // Provided methods
    fn is_neighbor(
        &self,
        own_pos: &Pos,
        ext_pos: &Pos,
        ext_inf: &Inf
    ) -> Result<bool, CalcError> {
        Ok(false)
    }

    fn react_to_neighbors(&mut self, neighbors: usize) -> Result<(), CalcError> {Ok(())}
}
```

Their default functionality is to never count and do no interactions.

## Examples

When representing cells as point-like particles, we can employ classical interactions given by
interaction potentials such as the
[`MorsePotential`](/docs/cellular_raza_building_blocks/struct.MorsePotential.html),
[`MiePotential`](/docs/cellular_raza_building_blocks/struct.MiePotential.html) or
[`BoundLennardJones`](/docs/cellular_raza_building_blocks/struct.BoundLennardJones.html) potential.

Other examples of complex interactions between cells are

- [Semi-Vertex](/showcase/semi-vertex-model) cells
- [Bacterial Rods](/showcase/bacterial-rods)
