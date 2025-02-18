---
title: 💥 Mechanics & Force
type: docs
weight: 20
math: true
---

## Mechanics

The [`Mechanics`](../cell/mechanics) concept of the cell is accompanied by the
[`SubDomainMechanics`](/cellular) trait for the domain.
It is responsible for applying boundary conditions to cells with the `apply_boundary` method.
This is often utilized to model finite enclosures with reflective boundary conditions.

```rust
fn apply_boundary(
    &self,
    pos: &mut Pos,
    vel: &mut Vel,
) -> Result<(), BoundaryError>;
```

When applying this boundary, we can directly modify the position and velocity of the cell.
This means we could theoretically bring them to en entirely different location.
However this might introduce logical bugs into our simulation if via the
[decomposition](../decomposition) scheme, the other region is decoupled from the one where the cell
is currently placed inside.
Also we might not be able to locate this new position correctly since we only assume that each
`SubDomain` contains some knowledge about their direct neighbor and not the whole `Domain`.

### Implementation

The
[`CartesianCuboidSubDomain`](/docs/cellular_raza_building_blocks/struct.CartesianCuboidSubDomain.html)
implements the `SubDomainMechanics` trait generically.
When simplifying its implementation, we can distinguish three main steps:

1. Check if the cell has left the domain
2. Move position back inside of domain and apply negative velocity in the opposite direction.
3. If the cell is still outside, report an error

We sketch a simplified implementation using the `VectorN` struct as position vector in `N`
dimensions as defined in [cell/mechanics](../../cell/mechanics).

```rust
impl SubDomainMechanics<VectorN> for Subdomain {
    fn apply_boundary(
        &self,
        position: &mut VectorN,
        velocity: &mut VectorN
    ) -> Result<(), BoundaryError> {
        /// Iterate over each spatial dimension
        for i in 0..N {
            // Check if the cell is below lower edge
            if position[i] < self.domain_min[i] {
                position[i] = two * self.domain_min[i] - position[i];
                velocity[i] = velocity[i].abs();
            }
            // Check if the cell is over the edge
            if position[i] > self.domain_max[i] {
                position[i] = two * self.domain_max[i] - position[i];
                velocity[i] = -velocity[i].abs();
            }
        }

        // If new position is still out of boundary return error
        for i in 0..D {
            if position[i] < self.domain_min[i] || position[i] > self.domain_max[i] {
                return Err(BoundaryError(format!(
                    "Particle is out of domain at position {:?}",
                    pos
                )));
            }
        }
    }
}
```

## Force

The [`SubDomainForce`](/docs/cellular_raza_concepts/trait.SubDomainForce.html) trait models how a
domain (through its subdomain) can exert forces onto a cell.
It depends on the [`Mechanics`](#mechanics) aspect and simply uses the
[position](../../cell/position) and [velocity](../../cell/velocity) of a cell.

### Implementation

This trait only requires to specify the `calculate_custom_force` function.
In this example, we implement a simple damping force which acts in the opposite direction of travel
proportionally to the velocity of the cell.

```rust
impl SubDomainForce<VectorN, VectorN, VectorN> for SubDomain {
    fn calculate_custom_force(
        &self,
        _pos: &VectorN,
        vel: &VectorN,
    ) -> Result<VectorN, CalcError> {
        Ok(- self.damping * vel)
    }
}
```
