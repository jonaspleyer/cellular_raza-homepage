---
title: Bacterial Branching Patterns
math: true
---

Spatio-temporal patterns of bacterial growth such as in _Bacillus Subtilis_ have been studied for
numerous years [\[1,2\]](#references).
They are typically modeled by a system of PDEs (Partial Differential Equations) which  describe
intracellular reactions, growth and spatial processes (usually via Diffusion), such as diffusion of
nutrients and movement of the cells.
Here, we only consider two variables: the spatial-temporal distribution $n(x,t)$ of the available
nutrients and the bacterial population density $b(x,t)$.
The rescaled set of coupled partial differential equations read:

$$\\begin{alignat}{5}
    \dot{n} &= &&\nabla^2n &- &f(n, b)\\\\
    \dot{b} &= d&&\nabla^2b &+ \theta &f(n, b)
\\end{alignat}$$

The function $f(n,b)$ describes the nutrient consumption by the bacterial metabolism and $d$ is the
ratio of diffusion constants.
The parameter $\theta$ is the "gain" in bacterial mass per nutrient volume resulting from growth
and division.

<!-- TODO reformulate this paragraph -->
One critique of these models is that the pattern will diffuse over the course of time, thus not
creating a persistent pattern.
This comes from modeling cellular motility via a diffusion equation.
However, stable patterns could be achieved if an equilibrium state exists where cells remain at
their locations.

## Mathematical Description

To formulate the above equations in an agent-based approach, we need to define cellular behaviour on
an individual-based level.

### Mechanics & Interaction

We represent cells as soft spheres with dynamics determined by
[`NewtonDamped2DF32`](/docs/cellular_raza_building_blocks/struct.NewtonDamped2DF32.html) and their
interaction given by the
[`MorsePotentialF32`](/docs/cellular_raza_building_blocks/struct.MorsePotentialF32.html)
type.

### Intra- & extracellular Reactions

The nutrient resource is freely diffusible throughout the simulation domain.
Individual cell-agents take up the extracellular nutrient resource and grow proportionally.
Only a fraction of the nutrients is converted to actual growth of cell volume.

$$\\begin{align}
    \dot{V}\_c &= \alpha u n_e\\\\
    \dot{n}\_e(x) &= D\Delta n\_e - u \sum\limits\_{c=1}^N n\_e(x)\delta(x-x\_c)
\\end{align}$$

The components of these PDEs describe the extracellular nutrients as well as the change in volume
of the individual cells.
$n_e$ is the spatially distributed extra-cellular nutrient concentration which undergoes diffusion
with the diffusion constant $D$ while $V_c$ is the volume of cell $c$ positioned at $x_c$.
The parameter $u$ is the uptake rate of the nutrient while $\alpha$ describes the conversion of the
nutrient by the cellular metabolism resulting in an increase of the volume $V_c$.

### Cycle

Once cells have reached a threshold $\tau$ in size (measured in multiple of given initial radius),
they will divide.
The newly created agents inherit all parameter values and thus the individual behaviour of their
mother cell.
They will continue to take up nutrients, process them and divide.
Usually, this cycle of producing new generations ceases due to depletion of nutrients after a few
division events.
For simplicity we ignore cell death in our simulation.

## Parameters

The parameter values have been chosen such that our simulation yields realistic results.

| Parameter | Symbol | Value |
| --- | --- | --- |
| Cell Radius | $R$ | $6.0 \text{ µm}$ |
| Potential Strength | $V_0$ | $2\text{ µm}^2\text{ }/\text{ min}^2$ |
| Potential Stiffness | $\lambda$ | $0.15\text{ µm}^{-1}$ |
| Damping Constant | $\lambda$ | $1\text{ min}^{-1}$ |
| Interaction Range | $\xi$ | $1.0  R$ |
| Uptake Rate | $u$ | $1.0 \text{ min}^{-1}$ |
| Growth Rate | $\alpha$ | $13.0 \text{ µm}^3\text{ l }/ \text{ µg}$ |
| Division threshold | $\tau$ | $2.0R$ |
| Diffusion Constant | $D$ | $80 \text{ µm}^2\text{ }/\text{ min}$ |

## Initial State

| Property | Symbol | Value |
| --- | --- | --- |
| Time Stepsize | $\Delta t$ | $0.12\text{ min}$ |
| Time Steps | $N_t$ | $20'000$ |
| Domain Size | $L$ | $3000\text{ µm}$ |
| Centered Starting Domain Size | $L_0$ | $300 \text{ µm}$ |
| Number of cells | $N_0$ | $400$ |
| Initial Nutrients | $n_e$ | $10 \text{ µg }/\text{ l}$ |

## Results

![](/showcase/bacterial-branching/cells_at_iter_0000060200.png)
<br>
<div style="text-align: center;">
    Figure 1: Final snapshot of the fully grown bacterial colony.
</div>

{{< callout type="info" >}}
The picture shown above was generated with modified parameters on a larger domain size of
$L=10000\mu m$ and with an increased number of simulation steps $t_\text{max}=6000$.
It is recommended to use multiple threads `--threads XY` to calculate this result.
{{< /callout >}}

## Movie

<video controls>
    <source src="/showcase/bacterial-branching/movie.mp4" type="video/mp4">
</video>

## Code

The simulation can be executed from a CLI tool which allows users to specify their own parameters.

{{< details title="CLI Arguments" closed="true" >}}
```text
# cargo run --bin cr_bacteria_branching -- --help
Usage: cr_bacteria_branching [OPTIONS]

Options:
  -h, --help     Print help
  -V, --version  Print version

Bacteria:
  -n, --n-bacteria-initial <N_BACTERIA_INITIAL>
          [default: 5]
  -r, --radius <RADIUS>
          [default: 6]
      --division-threshold <DIVISION_THRESHOLD>
          Multiple of the radius at which the cell will divide [default: 2]
      --potential-stiffness <POTENTIAL_STIFFNESS>
          [default: 0.15]
      --potential-strength <POTENTIAL_STRENGTH>
          [default: 2]
      --damping-constant <DAMPING_CONSTANT>
          [default: 1]
  -u, --uptake-rate <UPTAKE_RATE>
          [default: 1]
  -g, --growth-rate <GROWTH_RATE>
          [default: 13]

Domain:
  -d, --domain-size <DOMAIN_SIZE>
          Overall size of the domain [default: 3000]
      --voxel-size <VOXEL_SIZE>
          Size of one voxel containing individual cells.
          This value should be chosen `>=3*RADIUS`. [default: 30]
      --domain-starting-size <DOMAIN_STARTING_SIZE>
          Size of the square for initlal placement of bacteria [default: 100]
      --reactions-dx <REACTIONS_DX>
          Discretization of the diffusion process [default: 20]
      --diffusion-constant <DIFFUSION_CONSTANT>
          [default: 80]
      --initial-concentration <INITIAL_CONCENTRATION>
          [default: 10]

Time:
      --dt <DT>                        [default: 0.1]
      --tmax <TMAX>                    [default: 2000]
      --save-interval <SAVE_INTERVAL>  [default: 200]

Other:
      --threads <THREADS>  Meta Parameters to control solving [default: 2]
```
{{< /details >}}

### Simulation

{{< details title="Cargo" closed="true" >}}
{{< codeFromFile
    file="cellular_raza/cellular_raza-examples/bacterial_branching/Cargo.toml"
    filename="cellular_raza-examples/bacterial_branching/Cargo.toml"
>}}
{{< callout type="info" >}}
The dependencies which are derived from the workspace either via `workspace = true` or
`path="../../"` should be replaced with the versions used in the workspace
[`Cargo.toml`](https://github.com/jonaspleyer/cellular_raza/tree/master/Cargo.toml).
{{< /callout >}}
{{< /details >}}
{{< details title="Bacterial Properties" closed="true" >}}
{{< codeFromFile
    file="cellular_raza/cellular_raza-examples/bacterial_branching/src/bacteria_properties.rs"
    filename="cellular_raza-examples/bacterial_branching/src/bacterial_properties.rs"
>}}
{{< /details >}}
{{< details title="Domain" closed="true" >}}
{{< codeFromFile
    file="cellular_raza/cellular_raza-examples/bacterial_branching/src/subdomain.rs"
    filename="cellular_raza-examples/bacterial_branching/src/subdomain.rs"
>}}
{{< /details >}}
{{< details title="Main Simulation" closed="true" >}}
{{< codeFromFile
    file="cellular_raza/cellular_raza-examples/bacterial_branching/src/main.rs"
    filename="cellular_raza-examples/bacterial_branching/src/main.rs"
>}}
{{< /details >}}

### Plotting
{{< details title="Plotting" closed="true" >}}
{{< codeFromFile
    lang="python"
    file="cellular_raza/cellular_raza-examples/bacterial_branching/src/plotting.py"
    filename="cellular_raza-examples/bacterial_branching/src/plotting.rs"
>}}
{{< /details >}}

{{< callout type="info" >}}
We are currently working on a rewrite of this example using the [`chili`](/internals/backends/chili)
backend under
[`cellular_raza-examples/bacterial_branching`](https://github.com/jonaspleyer/cellular_raza/tree/master/cellular_raza-examples/bacterial_branching).
{{< /callout >}}

## References

[1]
K. Kawasaki, A. Mochizuki, M. Matsushita, T. Umeda, and N. Shigesada,
“Modeling Spatio-Temporal Patterns Generated byBacillus subtilis,”
Journal of Theoretical Biology, vol. 188, no. 2.
Elsevier BV, pp. 177–185, Sep. 1997.
doi: [10.1006/jtbi.1997.0462](https://doi.org/10.1006/jtbi.1997.0462).

[2]
M. Matsushita et al.,
“Interface growth and pattern formation in bacterial colonies,”
Physica A: Statistical Mechanics and its Applications, vol. 249, no. 1–4.
Elsevier BV, pp. 517–524, Jan. 1998.
doi: [10.1016/s0378-4371(97)00511-6](https://doi.org/10.1016/S0378-4371(97)00511-6).
