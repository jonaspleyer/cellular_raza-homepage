---
title: ↗ Velocity
weight: 5
math: true
---

The [`Veloctiy`](/docs/cellular_raza_concepts/trait.Velocity.html) concept is responsible for the
spatial velocity representation of the cellular agent.
In almost all cases, the types used in this trait will match with the
[Position](/internals/concepts/cell/position) concept.

## Example: Point-Like Particle

The most widely-known example is that of representing cellular agents as point-like objects.

In this case, cells are described by a postion vector of $n$ (typically $n=2,3$) dimensions which
we will call `VectorN` for simplicity.
Their corresponding velocity is also given by a vector of dimension $n$.

$$
    \vec{v} = \begin{bmatrix}
        x_1\\\\
        x_2\\\\
        \vdots\\\\
        x_n
    \end{bmatrix}
$$

```rust
impl Velocity<VectorN> for MyCell {
    fn velocity(&self) -> VectorN {
        self.vel.clone()
    }

    fn set_velocity(&mut self, velocity: &VectorN) {
        self.vel = velocity.clone();
    }
}
```


## More Examples

- [Semi-Vertex agents](/showcase/semi-vertex-model)
- [Bacterial Rods](/showcase/bacterial-rods)
