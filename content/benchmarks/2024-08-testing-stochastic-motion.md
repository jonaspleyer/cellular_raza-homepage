---
title: "Testing Stochastic Motion via the Fluctuation-Dissipation Theorem"
date: 2024-08-24
math: true
---

## Testing Setup

### Brownian Dynamics

[`Brownian3D`](/docs/cellular_raza_building_blocks/struct.Brownian3D.html)

$$\\begin{equation}
    \dot{X} = -\frac{D}{k_B T} \nabla V(X) + \sqrt{2D}R(t)
\\end{equation}$$


#### Parameters

| Symbol    | Parameter             | Description           |
| --------- | --------------------- | --------------------- |
| $X$       | `pos`                 | Position of Particle  |
| $D$       | `diffusion_constant`  | Diffusion Constant    |
| $k_B T$   | `kb_temperature`      | Product of Boltzmann constant and temperature. |


$$\\begin{equation}
    \left<r^2(t)\right> = 2d D t
\\end{equation}$$

### Langevin Dynamics

[`Langevin3D`](/docs/cellular_raza_building_blocks/struct.Langevin3D.html)

$$\\begin{equation}
    M \ddot{X} = - \nabla V(X) - \lambda M \dot{X} + \sqrt{2M\lambda k_B T}R(t)
\\end{equation}$$

$$\\begin{equation}
    \left<r^2(t)\right> =
        v^2(0) \frac{1-\text{e}^{-\lambda t}}{\lambda^2}
        - \frac{d k_B T}{m\lambda^2}
            \left(1-\text{e}^{-\lambda t}\right)
            \left(3 - \text{e}^{-\lambda t}\right)
        + \frac{2 d k_B T}{m\lambda}t
\\end{equation}$$

## Results

## Discussion

## References


