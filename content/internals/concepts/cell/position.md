---
title: ⌖ Position
weight: 3
math: true
---

The [`Position`](/docs/cellular_raza_concepts/trait.Position.html) concept is responsible for the
spatial representation of the cellular agent.

## Example: Point-Like Particle

The most widely-known example is that of representing cellular agents as point-like objects.

In this case, cells are described by a postion vector of $n$ (typically $n=2,3$) dimensions which
we will call `VectorN` for simplicity.

$$
    \vec{x} = \begin{bmatrix}
        x_1\\\\
        x_2\\\\
        \vdots\\\\
        x_n
    \end{bmatrix}
$$

If we implement these properties, we obtain
```rust
struct MyCell {
    pos: VectorN,
}

impl Position<VectorN> for MyCell {
    fn pos(&self) -> VectorN {
        self.pos.clone()
    }

    fn set_pos(&mut self, pos: &VectorN) {
        self.pos = pos.clone();
    }
}
```

## More Examples

- [Semi-Vertex agents](/showcase/semi-vertex-model)
- [Bacterial Rods](/showcase/bacterial-rods)
