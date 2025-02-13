---
title: Bacterial Rods
date: 2024-06-05
math: true
---

Bacteria exist in many physical shapes such as spheroidal, rod-shaped or spiral
[\[1,2\]](#references).
We set out to define a simple yet effective coarse-grained mechanical cellular model to describe
the motion of rod-shaped bacteria.

## Mathematical Description

To model the spatial mechanics of elongated bacteria [\[3\]](#references), we represent them as a
collection of auxiliary vertices $\\{\\vec{v}\_i\\}$ which are connected by springs in ascending
order.
Furthermore, we assume that the cells are flexible which is described by their curvature property.
A force $\vec{F}$ interacting between cellular agents determines the radius (thickness) of the
rods and an attractive component can model adhesion between cells.

### Mechanics

The internal force acting on vertex $\\vec{v}\_i$ can be divided into 2 contributions coming from
the 2 springs pulling on it.
We assume that the segment lengths $l$ and tension $\gamma$ are spatially independent.
In the case when $i=0,N\_\\text{vertices}$, this is reduced to only one internal component.
We denote with $\vec{c}\_{i}$ the edge between two vertices

$$\begin{align}
    \vec{c}\_i = \vec{v}\_{i}-\vec{v}\_{i-1}
\end{align}$$

and can write down the resulting force

$$\\begin{align}
    \vec{F}\_{i,\text{springs}} =
        &-\gamma\left(1 - \\frac{l}{\left|\vec{c}\_i\right|}\right)
        \vec{c}\_i\\\\
        &+ \gamma\left(1 - \\frac{l}{\left|\vec{c}\_{i+1}\right|}\right)
        \vec{c}\_{i+1}
\\end{align}$$

In addition to springs between individual vertices $\vec{v}\_i$, we assume that each angle at a
vertex between edges is subject to a force indiced by curvature.
We assume that we can model the mechanical properties of the bacterium as an elastic rod.
We define $\alpha_i = \sphericalangle(\vec{c}\_{i-1},\vec{c}\_i)$ as the angle between adjacent
edges.
The bending force can be assumed to be proportional to the curvature $\kappa_i$ at each vertex
$\vec{v}\_i$

$$\begin{equation}
    \kappa\_i = 2\tan\left(\frac{\alpha\_i}{2}\right).
\end{equation}$$

The resulting force acts along the angle bisector which can be calculated from the edge vectors.
The forces acting on vertices $\vec{v}\_i,\vec{v}\_{i-1},\vec{v}\_{i+1}$ are given by

$$\begin{align}
    \vec{F}\_{i,\text{curvature}} &= \eta\kappa_i
        \frac{\vec{c}\_i - \vec{c}\_{i+1}}{|\vec{c}\_i-\vec{c}\_{i+1}|}\\\\
    \vec{F}\_{i-1,\text{curvature}} &= -\frac{1}{2}\vec{F}\_{i,\text{curvature}}\\\\
    \vec{F}\_{i+1,\text{curvature}} &= -\frac{1}{2}\vec{F}\_{i,\text{curvature}}
\end{align}$$

where $\eta\_i$ is the rigidity at vertex $\vec{v}\_i$ (see
[Figure 1](#fig:cell-mechanics-interaction)).
We can see that the curvature force does not move the overall center of the rod in space.
The total force is the sum of external and interal forces.

$$\begin{equation}
    \vec{F}\_{i,\text{total}} = \vec{F}\_{i,\text{springs}}+ \vec{F}\_{i,\text{curvature}}
        + \vec{F}\_{i,\text{external}}
\end{equation}$$

and are integrated via

$$\begin{align}
    \partial\_t^2 \vec{x} &= \partial_t\vec{x} + \sqrt{2D}\vec{\xi}\\\\
    \partial\_t\vec{x} &= \vec{F}\_\text{total} - \lambda \partial_t\vec{x}
\end{align}$$

where $D$ is the diffusion constant and  $\vec{\xi}$ is the wiener process (compare with
[brownian motion](/docs/cellular_raza_building_blocks/struct.Brownian3D.html)).
These mechanics are available under the
[`RodMechanics`](/docs/cellular_raza_building_blocks/struct.RodMechanics.html) building block.

<div style="text-align: center;" id="fig:cell-mechanics-interaction">
    <img src="/showcase/bacterial-rods/mechanics.png" width=500>
    Figure 1: One cell-agent consists of multiple vertices which are connected by springs.
    Any angle which deviates from $\pi$ between the adjacent edges introduces a curvature force.
    The area indicated around the polygon is the collections of points with distance less than $R$
    to some point $\vec{p}$ on the segments.
    It visualizes the interaction range.
</div>

### Interaction
When calculating forces acting between the cells, we can use a simplified model to circumvent the
numerically expensive integration over the complete length of the rod.
Given a vertex $\vec{v}\_i$ on one cell, we calculate the closest point $\vec{p}$ on the polygonal
line given by the vertices $\\{\vec{w}\_j\\}$ of the interacting cell.
Furthermore we determine the value $q\in[0,1]$ such that

$$\begin{equation}
    \vec{p} = (1-q)\vec{w}\_j + q\vec{w}\_{j+1}
\end{equation}$$

for some specific $j$.
The force is then calculated between the points $\vec{v}\_i$ and $\vec{p}\_i$ and acts on the
vertex $\vec{w}\_i,\vec{w}\_{i+1}$ with relative strength $(1-q)$ and $q$.

$$\begin{align}
    \vec{F}\_{i,\text{External}} = \vec{F}(\vec{v}\_i,\vec{p})
\end{align}$$

We provide the [`RodInteraction`](/docs/cellular_raza_building_blocks/struct.RodInteraction.html)
struct to convert a point-wise interaction to a rod-rod interaction potential.
In our case, we use the
[`MorsePotential`](/docs/cellular_raza_building_blocks/struct.MorsePotential.html) building block.
We detect neighbors who are in range of $2R$ where $R$ is the radius of interaction.

### Cycle
To simulate proliferation, we introduce a growth term for the spring lengths $l$.
We reduce the growth rate with increasing number of neighbors $n$.

$$\begin{equation}
    \partial\_t l = \mu \left(1 - \frac{\min(n,N)}{N}\right)
\end{equation}$$

which will increase the length of the cell indefenitely unless we impose a condition for the
[division event](/internals/concepts/cell/cycle).
We define a threshold (in our case double of the original length) for the total length of the
cell at which it divides.
To construct a new cell, we cannot simply copy the existing one twice, but we also need to adjust
internal parameters in the process.
The following actions need to be taken for the old and new agent.

1. Assign a new growth rate (pick randomly from uniform distribution in
   $[0.8\text{ }\mu\_0,1.2\text{ }\mu\_0]$ where $\mu\_0$ is some fixed value)
2. Assign new positions
    1. Calculate new spring lengths
    $$\tilde{l} = l\left(\frac{1}{2} - \frac{r}{\sum\limits\_i l}\right)$$
    2. Calculate middle of old cell
    $$\vec{m} = \frac{1}{N\_\text{vertices}}\sum\limits\_i\vec{v}\_i$$
    3. Calculate positions of new vertices $\vec{w}\_i$
    $$\\begin{align}
        q\_i &= \frac{i}{N\_\text{vertices}}\\\\
        \vec{w}\_{i,\text{new},\pm} &= (1-q\_i)\vec{m} + q\_i(\vec{v}_{\pm\text{start}} - \vec{m})
    \end{align}$$

### Domain
In this simulation example, the domain plays an important role.
The domain consists of an elongated box with reflective boundary conditions.
Cells are initially placed in the left part.
Due to their repulsive potential at short distances, they begin to push each other into the
remaining space.

## Parameters

| Parameter | Symbol | Value |
| --- | --- | --- |
| [`RodMechanics`](/docs/cellular_raza_building_blocks/struct.RodMechanics.html) |
| Spring Tension | $\gamma$ | $10\text{ min}^{-2}$ |
| Diffusion Constant | $D$ | $0$ $\text{µm}^2\text{min}^{-2}$ |
| Damping | $\lambda$ | $1.5\text{min}^{-1}$ |
| Spring Length | $l$ | $3\text{ µm}$ |
| Rigidity | $\eta$ | $2$ $\text{µm min}^{-1}$ |
| [`MorsePotential`](/docs/cellular_raza_building_blocks/struct.MorsePotential.html) |
| Interaction Radius | $R$ | $3\text{ µm}$ |
| Potential Stiffness | $\lambda$ | $0.5\text{ µm}$ |
| Cutoff | | $5\text{ µm}$ |
| Strength | $V_0$ | $0.1\text{ µm}^2\text{min}^{-2}$ |
| **Cycle** |
| Division Threshold | | $6$ µm |
| Growth Rate | $\mu$ | $0.1\text{ µm min}^{-1}$ |
| |
| [`CartesianCuboidRods`](/docs/cellular_raza_building_blocks/struct.CartesianCuboidRods.html)
| Domain Length | $L$ | $50\text{ µm}$ |
| |
| **Time** |
| Stepsize | $\Delta t$ | $0.1\text{ min}$ |
| Save Interval | $\Delta t_\text{save}$ | $2.5\text{ min}$ |
| Total Time | $T$ | $25\text{ h}$ |

## Results
### Initial Snapshot
![](/showcase/bacterial-rods/0000000025.png)

### Movie
<br>
<video controls>
    <source src="/showcase/bacterial-rods/movie.mp4" type="video/mp4">
</video>

### Final Snapshot
![](/showcase/bacterial-rods/0000015000.png)

## Code
The code is part of the examples and can be found in the official github repository under
[bacterial-rods](https://github.com/jonaspleyer/cellular_raza/tree/master/cellular_raza-examples/bacterial_rods).

{{< details title="Cargo" closed="true" >}}
{{< codeFromFile
    file="cellular_raza/cellular_raza-examples/bacterial_rods/Cargo.toml"
    filename="cellular_raza-examples/bacterial_rods/Cargo.toml"
>}}
{{< callout type="info" >}}
The dependencies which are derived from the workspace either via `workspace = true` or
`path="../../"` should be replaced with the versions used in the workspace
[`Cargo.toml`](https://github.com/jonaspleyer/cellular_raza/tree/master/Cargo.toml).
{{< /callout >}}
{{< /details >}}
{{< details title="Main Simulation" closed="true">}}
{{< codeFromFile
    file="cellular_raza/cellular_raza-examples/bacterial_rods/src/main.rs"
    filename="cellular_raza-examples/bacterial_rods/src/main.rs"
>}}
{{< /details >}}
{{< details title="Plotting" closed="true">}}
{{< codeFromFile
    file="cellular_raza/cellular_raza-examples/bacterial_rods/plotter.py"
    filename="cellular_raza-examples/bacterial_rods/plotter.py"
    lang="python"
>}}
{{< /details >}}

## References

<!-- TODO maybe find better citaions here -->

[1] A. Zapun, T. Vernet, and M. G. Pinho,
“The different shapes of cocci,” FEMS Microbiology Reviews, vol. 32, no. 2.
Oxford University Press (OUP), pp. 345–360, Mar. 2008.
doi: [10.1111/j.1574-6976.2007.00098.x](https://doi.org/10.1111%2Fj.1574-6976.2007.00098.x)

[2] K. D. Young,
“The Selective Value of Bacterial Shape,” Microbiology and Molecular Biology Reviews, vol. 70, no. 3.
American Society for Microbiology, pp. 660–703, Sep. 2006.
doi: [10.1128/mmbr.00001-06](https://doi.org/10.1128/mmbr.00001-06).

[3] C. Billaudeau et al.,
“Contrasting mechanisms of growth in two model rod-shaped bacteria,”
Nature Communications, vol. 8, no. 1.
Springer Science and Business Media LLC, Jun.
07, 2017. [doi: 10.1038/ncomms15370](https://doi.org/10.1038/ncomms15370).
