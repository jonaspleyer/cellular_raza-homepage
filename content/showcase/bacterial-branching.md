---
title: Branching Patterns of Bacillus Subtilis
math: true
---

This simulation was inspired by the bacterial patterns first mathematically described in
[\[1,2\]](#references).
These patterns can be described by considering two variables: the spatial-temporal distribution $n$
of the available nutrient and the bacterial population density $b$.
Together with the ratio of diffusion of both components $d$ the set of coupled partial differential
equations read:

$$\\begin{alignat}{5}
    \dot{n} &= &&\nabla^2n &- &f(n, b)\\\\
    \dot{b} &= d&&\nabla^2b &+ \theta &f(n, b)
\\end{alignat}$$

The function $f(n,b)$ describes the nutrient consumption by the bacterial metabolism.
The parameter $\theta$ is the "gain" in bacterial mass per nutrient volume resulting from growth
and division.

One critique of these models is that the pattern will diffuse over the course of time, thus not
creating a persistent pattern.
This comes from modeling cellular motility via a diffusion equation.
However stable patterns could be achieved if an equilibrium state exists where cells remain at
their locations.

## Mathematical Description
### Mechanics & Interaction

We represent cells as soft spheres with the
[MorsePotential](/docs/cellular_raza_building_blocks/struct.MorsePotential.html).

### Intra- & extracellular Reactions

The nutrient resource is freely diffusible throughout the simulation domain.
Individual cell-agents take up the extracellular nutrient resource and grow proportional to the
intracellular nutrient concentration.
Only a fraction of the nutrients is converted to actual growth of cell volume.

$$\\begin{align}
    \dot{n}\_i^c &= u(n\_e(x\_c) - n\_i^c) - (\alpha + \sigma)n\_i^c\\\\
    \dot{V}\_c &= \alpha n\_i^c V\_c \left(1 - \frac{V\_c}{V\_\text{max}}\right)\\\\
    \dot{n}\_e &= D\Delta n\_e - u \sum\limits\_{c=1}^N \delta(x-x\_c)(n\_e-n\_i)
\\end{align}$$

The components of these PDEs describe the extracellular and intracellular nutrients as well as the
volume of the individual cell.
$n_e$ is the spatially distributed extra-cellular nutrient concentration which undergoes diffusion
with the diffusion constant $D$ while $n^c_i$ is the intra-cellular nutrient concentration of cell 
$c\in\\{1,\dots,N\\}$ positioned at $x_c$.
The volumeo f cell $c$ is given by $V_c$.
The parameter $u$ is the uptake rate of the nutrient while $\alpha$ describes the consumption of the
nutrient by the cellular metabolism resulting in an increase of the volume $V_c$.
In contrast, $\sigma$ degrades the intracellular nutrients 
After reaching $90\\%$ of the maximum volume $V_\text{max}$ the cell divides into two equally sized
cells with volume $V_\text{max}/2$.
The gain θ is approximately given by $\theta\approx \log(2) \alpha u/ (u + \alpha)$.
If the uptake rate is very large the gain is limited by
the nutrient processing rate $\alpha$ (the nutrient metabolism), but in the case where the nutrient
metabolism is very fast (efficient) the total gain is limited by the uptake rate $u$.

### Cycle

Once cells have reached a minimum age $\tau$ and nutrient threshold $n_t$, they will divide.
The newly created agents behave exactly the same as their parent and they will continue to take up
nutrients, process them and divide.
This also means, we do not alter their internal parameters during the division process.
Usually, this cycle of producing new generations ceases due to low concentration of the nutrient
resource after a few division events.
Our simulation duration is chosen short enough such that the colony remains in its equilibrium
state and we thus do not need to model cell death.

## Parameters

| Parameter | Symbol | Value |
| --- | --- | --- |
| Cell Radius | $R$ | $6.0\hspace{0.25em}\mu \text{m}$ |
| Potential Strength | $V_0$ | $2\hspace{0.25em}\mu\text{m}^2\hspace{0.25em}\text{min}^{-2}$ |
| Damping Constant | $\lambda$ | $2\hspace{0.25em}\text{min}^{-1}$ |
| Interaction Range | $\xi$ | $1.5 \hspace{0.25em} R$ |
| Turnover Rate | $\sigma$ | $0.025 \hspace{0.25em}\text{min}^{-1}$ |
| Uptake Rate | $u$ | $0.05 \hspace{0.25em}\text{min}^{-1}$ |
| Growth Rate | $\alpha$ | $0.1\hspace{0.25em}\mu m^2\hspace{0.25em}\mu g^{-1}\hspace{0.25em}l$ |
| Nutrient Division Threshold | $n_t$ | $0.8\hspace{0.25em}\mu g\hspace{0.25em} l^{-1}$ |
| Age threshold | $\tau$ | $65\hspace{0.25em}\text{min}$ |
| Diffusion Constant | $D$ | $12\hspace{0.25em}\mu m^2 \hspace{0.25em}\text{min}^{-1}$ |

## Initial State

| Property | Symbol | Value |
| --- | --- | --- |
| Time Stepsize | $\Delta t$ | $0.25\hspace{0.25em}\text{min}$ |
| Time Steps | $N_t$ | $20'000$ |
| Domain Size | $L$ | $3000\hspace{0.25em}\mu\text{m}$ |
| Centered Starting Domain Size | $L_0$ | $300\hspace{0.25em}\mu m$ |
| Number of cells | $N_0$ | $400$ |
| Initial Intracellular Nutrients | $n_i^c$ | $1.0 \hspace{0.25em}\mu g\hspace{0.25em} \hspace{0.25em}l^{-1}$ |
| Initial Extracellular Nutrients | $n_e$ | $25\hspace{0.25em}\mu g\hspace{0.25em} l^{-1}$ |

## Results

![](/showcase/bacterial-branching/bacteria_cells_at_iter_0000088000.png)
<br>
<div style="text-align: center;">
    Figure 1: Final snapshot of the fully grown bacterial colony.
</div>

{{< callout type="info" >}}
The picture shown above was generated with modified parameters on a larger domain size of
$L\approx 30000\hspace{0.25em}\mu m$ and with an increased number of simulation steps.
Unfortunately the exact numbers have been lost.
{{< /callout >}}

## Code

{{< callout type="warning" >}}
The code for this example is implemented via the
[`cpu_os_threads`](/internals/backends/cpu-os-threads) backend.
This backend is not receiving new updates or further development.
We are currently working at porting the existing code to the [`chili`](/internals/backends/chili)
backend.
{{< /callout >}}

{{< details title="Bacterial Properties" closed="true" >}}
{{< codeFromFile
    file="cellular_raza/cellular_raza-examples/bacteria_population/src/bacteria_properties.rs"
    filename="cellular_raza-examples/bacteria_population/src/bacterial_properties.rs"
>}}
{{< /details >}}
{{< details title="Main Simulation" closed="true" >}}
{{< codeFromFile
    file="cellular_raza/cellular_raza-examples/bacteria_population/src/main.rs"
    filename="cellular_raza-examples/bacteria_population/src/main.rs"
>}}
{{< /details >}}
{{< details title="Plotting" closed="true" >}}
{{< codeFromFile
    file="cellular_raza/cellular_raza-examples/bacteria_population/src/plotting.rs"
    filename="cellular_raza-examples/bacteria_population/src/plotting.rs"
>}}
{{< /details >}}

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
