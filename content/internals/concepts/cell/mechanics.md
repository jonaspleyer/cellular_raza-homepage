---
title: 💥 Mechanics
type: docs
weight: 10
math: true
---

The [`Mechanics`](/docs/cellular_raza_concepts/trait.Mechanics.html) and
[`SubDomainMechanics`](/docs/cellular_raza_concepts/domain_new/trait.SubDomainMechanics.html) traits
specify the physical representation of cellular agents inside the simulation domain.
The traits act on 3 distinct types for position, velocity and forces acting on the cell-agents.
In many examples, these types are identical.
The subdomain trait is responsible for keeping cell-agents inside the specified simulation
domain.

The solver of the chosen [backend](/internals/backends) must be told how to increment position and
velocity of the cell.
This is done by the `calculate_increment` function.

```rust
fn calculate_increment(&self, force: For) -> Result<(Pos, Vel), CalcError> {
    // Do some calculations
    ...
    // Return increments
    Ok((...,...))
}
```

If the user decides to leave out the [Interaction](/internals/concepts/cell/interaction) concept,
we will assume a force of zero as specified by the
[`num::Zero`](https://docs.rs/num/latest/num/traits/trait.Zero.html) trait when numerically solving
the equations.

## Difference to [Interaction](/internals/concepts/cell/interaction) concept

To describe physical interactions between cells when in proximity of each other, we also provide the
[Interaction](/internals/concepts/cell/interaction) concept.
In contrast, the Mechanics concepts is only concerned with the physical representation and physical
motion of one cell on its own.
Although these two concepts seem to be similar in nature, it can be benefitial to separate them not
only conceptually but also for practical reasons.
For example we can seamlessly change between the
[`Brownian3D`](/docs/cellular_raza_building_blocks/struct.Brownian3D.html) and
[`Langevin3D`](/docs/cellular_raza_building_blocks/struct.Langevin3D.html) struct without having to
alter the currently used Interaction type (if present).

The [`Mechanics`](/docs/cellular_raza_concepts/trait.Mechanics.html) trait requires the
[`Position`](/docs/cellular_raza_concepts/trait.Position.html) and
[`Velocity`](/docs/cellular_raza_concepts/trait.Velocity.html) traits which provide setters and
getters for the spatial cellular representation.

## Examples
A wide variety of cellular repesentations can be realized by this trait.
`cellular_raza` provides some of them in its
[`cellular_raza_building_blocks`](/docs/cellular_raza_building_blocks) crate.

### Newtonian Dynamics
To illustrate how the [`Mechanics`](/docs/cellular_raza_concepts/Mechanics.html) concept works, we
take alook at the most simple representation as
[point-like particles](/internals/concepts/cell/position) under the effect of
standard newtonian dynamics.

In this case, cells are described by a postion and velocity vector of $n$ (typically $n=2,3$)
dimensions which we will call `VectorN` for simplicity.

$$
    \vec{x} = \begin{bmatrix}
        x_1\\\\
        x_2\\\\
        \vdots\\\\
        x_n
    \end{bmatrix}
    \hspace{1cm}
    \vec{v} = \begin{bmatrix}
        v_1\\\\
        v_2\\\\
        \vdots\\\\
        v_n
    \end{bmatrix}
$$

A third type is also of importance which describes the force acting on the cell.
In our case we can assume the same form as before

$$
    \vec{F} = \begin{bmatrix}
        F_1\\\\
        F_2\\\\
        \vdots\\\\
        F_n
    \end{bmatrix}.
$$

If we assume simple newtonian dynamics without any additional stochastic effects, we can write down
the equations of motion
$$\begin{align}
    \dot{\vec{x}} &= \vec{v}\\\\
    \dot{\vec{v}} &= \frac{1}{m}\vec{F}.
\end{align}$$
Note that we assume that our cell has a certain mass, which may also be set to $m=1$ and thus
neglected in some implementations.

```rust
struct MyCell {
    pos: VectorN,
    vel: VectorN,
    mass: f64,
}
```

The implementation of the [`Mechanics`]() trait reads:

```rust
// Here is the magic
impl Mechanics<VectorN, VectorN, VectorN> for MyCell {
    fn calculate_increment(
        &self,
        force: VectorN
    ) -> Result<(VectorN, VectorN), CalcError> {
        let dx = self.vel();
        let dv = 1.0/self.mass * force;
        Ok((dx, dv))
    }
}
```

These dynamics together with an additional damping constant are pre-defined as the
[`NewtonDamped2D`](/docs/cellular_raza_building_blocks/NewtonDamped2D.html) struct.

### Brownian Dynamics

The standard brownian motion stochastic differential equation is given by
$$\begin{equation}
    \dot{\vec{x}} = -\frac{D}{k_B T}\nabla V(x) + \sqrt{2D}R(t).
\end{equation}$$

The variable $R(t)$ is the [wiener process](https://en.wikipedia.org/wiki/Wiener_process)
[\[1\]](#references).
To model this stochastic contribution, we use the `get_random_contribution` method of the
[`Mechanics`](/docs/cellular_raza_concepts/trait.Mechanics.html) trait.

```rust
struct MyCell {
    pos: VectorN,
}

impl Mechanics<VectorN> for MyCell {
    fn get_random_contribution(
        &self,
        rng: &mut rand_chacha::ChaCha8Rng,
        dt: f64,
    ) -> Result<(VectorN, VectorN), RngError> {
        let dpos = (2.0 as $float_type * self.diffusion_constant).sqrt()
            * wiener_process(
            rng,
            dt
        )?;
        let dvel = VectorN::zeros();
        Ok((dpos, dvel))
    }

    fn calculate_increment(
        &self,
        force: VectorN,
    ) -> Result<(VectorN, VectorN), CalcError> {
        let dx = self.diffusion_constant / self.kb_temperature * force;
        Ok((dx, VectorN::zeros()))
    }
}

```

## References

[1]
N. Wiener,
[Collected Works](https://mitpress.mit.edu/9780262230704/norbert-wiener-collected-works/):
v. 1. London, England: MIT Press,
1976.
