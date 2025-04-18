---
title: Semi-Vertex Model
date: 2024-04-11
math: true
---

Vertex models are a very popular choice in describing multicellular systems.
They are actively being used in great variety such as to describe mechanical properties of plant
cells [\[1\]](#references) or organoid structures of epithelial
cells [\[2,3\]](#references).

## Mathematical Description
In this model, we are only concerned with cellular forces and their representation in space.
One single cell-agent can be described by a collection of (ordered) vertices which in turn also
allows for a dual description in terms of edges.

$$\\begin{align}
    \\{\vec{v}\_i\\}\_{i=0\\dots n}\\\\
    \vec{v}\_i = \begin{bmatrix}v_{i,0}\\\\v_{i,1}\end{bmatrix}
\\end{align}$$

In the following text, we assume that vertices are always ordered (clockwise or anti-clockwise)
and this ordering is identical for every cell in our simulation.

### Mechanics
Every vertex is connected to its next neighbours via springs with an associated length $d$ and
spring constant $\\gamma$.
The potential used to calculate the force $F_i$ acting along the edges of the cell between vertex
$i$ and $i+1$ is given by

$$\\begin{align}
    \vec{F}\_{\text{edges},i} &= - \\gamma \\left(||\vec{v}\_i - \vec{v}\_{i+1}|| - d\\right)
    \frac{\vec{v}\_i - \vec{v}\_{i+1}}{||\vec{v}\_i - \vec{v}\_{i+1}||}\\\\
    %V\_\text{edges} &= \sum\limits\_{i=0}^n \\frac{\\gamma}{2}\left(d\_i - d\right)^2
\\end{align}$$

where $||\vec{v}\_i - \vec{v}\_{i+1}||$ is the distance between individual vertices.

From the length of the individual edges, we can determine the total area $A$ of the cell when
the equilibrium configuration of a perfect polygon is reached:

$$\\begin{equation}
    A = d^2\sum\limits_{i=0}^{n-1}\frac{1}{2\sin(\pi/n)}.
\\end{equation}$$

However, since the individual vertices are mobile, we require an additional mechanism which
simulates a central pressure $P$ depending on the currently measured volume $\tilde{V}$.
This area can be calculated by summing over the individual areas of the triangles given by
two adjacent vertices and the center point $\vec{c}=\sum\_i\vec{v}\_i/(n+1)$.
They can be calculated by using the parallelogramm formula

$$\\begin{align}
    \tilde{A}\_i &=
    \det\\begin{vmatrix}
        \vec{v}\_{i+1} - \vec{c} & \vec{v}\_i - \vec{c}
    \\end{vmatrix}\\\\
    &= \det\\begin{pmatrix}
        (\vec{v}\_{i+1} - \vec{c})\_0 & (\vec{v}\_{i} - \vec{c})\_0\\\\
        (\vec{v}\_{i+1} - \vec{c})\_1 & (\vec{v}\_{i} - \vec{c})\_1
    \\end{pmatrix}\\\\
    \tilde{A} &= \sum\limits_{i=0}^{n-1}\tilde{A}\_i
\\end{align}$$

The resulting force then points from the center of the cell $\vec{c}$ towards the
individual vertices $\vec{v}\_i$.

$$\\begin{align}
    \vec{F}\_{\text{pressure},i} = P\\left(A-\\tilde{A}\\right)\frac{\vec{v}\_i - \vec{c}}{||\vec{v}\_i - \vec{c}||}
\\end{align}$$

These mechanical considerations alone are enough to yield perfect polygons configurations for
individual cells without any interactions.
We also take into account that cells are surrounded by viscuous liquid which introduces a damping
effect given by a force proportional to the velocity at each vertex

$$\begin{equation}
    \vec{F}\_{\text{damping},i} = - \lambda \dot{\vec{v}}.
\end{equation}$$


If we also take into account an external force acting on the cell, the total force acting on the
individual vertices $\vec{v}\_i$ can be calculated via

$$\\begin{equation}
    \vec{F}\_{\text{total},i} = \vec{F}\_{\text{external},i} + \vec{F}\_{\text{edges},i}
        + \vec{F}\_{\text{pressure},i} + \vec{F}\_{\text{damping},i}.
\\end{equation}$$

### Interaction

For the sake of simplicity, we model cellular interactions by calculating forces between each vertex
and its closest neighbor on the other cells polygon.
Let us denote the vertices of the two cells in question with $\\{\vec{v}_i\\}$ and
$\\{\vec{w}_j\\}$.

Given a vertex $\vec{v}\_i$ of the first cell and the other cells vertices $\\{\vec{w}_j\\}$ we
asses if the vertex $v_i$ is contained in the polygon $\\{\vec{w}\_j\\}$ and calculate either the
inside or a outside interaction force.
In this way, by iterating over all vertices $\vec{v}\_i$, we can calculate the total external force
$\vec{F}\_\text{external}$ as the sum of all individual contributions.
The same procedure when switching $\vec{v}\_i$ and $\vec{w}\_j$ results in a symmetric interaction.

#### Case 1: Outside Interaction
In this case, we assume that the vertex $\vec{v}_i$ in question is not inside the other cell.
We make the simplifying assumption that each vertex $\vec{v}_i$ is interacting with the closest
point on the outer edge of the other cell.
Given these sets of vertices, we calculate for each vertex $\vec{v}_i$ the closest
point

$$\\begin{equation}
    \vec{p} = (1-q)\vec{w}_j + q\vec{w}\_{j+1}
\\end{equation}$$

where the value $q\in[0,1]$ and the index $j$ need to be chosen such that the distance
$||\vec{v}\_i-\vec{p}||$ is minimal (assuming that we set $\vec{w}\_{j+1}=\vec{w}\_1$ when
$j=N\_\text{vertices}$).
The force acting on this vertex can now be calculated

$$\\begin{equation}
    \vec{F}\_{\text{outside},i} = \vec{\nabla}V(\vec{v}_i, \vec{p})
\\end{equation}$$

by using the points $\vec{v}_i$ and $\vec{p}$.
The force acting on the other cell acts on the vertices $j$ and $j+1$ with relative strength $1-q$
and $q$ respectively

$$\\begin{alignat}{5}
    &\vec{F}\_{\text{other,outside},j} &=& - &(1-q)&\vec{\nabla} V(\vec{v}_i,\vec{p})\\\\
    &\vec{F}\_{\text{other,outside},j+1} &=& &-q&\vec{\nabla}V(\vec{v}_i,\vec{p}).
\\end{alignat}$$

{{<callout type="info" >}}
In the actual implementation of this approach, we additionally use a bounding box around each cell
to quickly identify if a given vertex is outside the other cell.
{{< /callout >}}

#### Case 2: Inside Interaction
In the second case, a vertex of the other cell $\vec{w}_j$ has managed to move inside.
Here, a repulsive force $W$ acts which is responsible for pushing the vertex outwards.
The force is calculated between the center of our cell

$$\\begin{equation}
    \vec{v}_c = \frac{1}{N\_\text{vertices}}\sum\limits_i \vec{v}_i
\\end{equation}$$

and the external vertex in question.
The force which is calculated this way acts in equal parts on all vertices.

$$\\begin{alignat}{5}
    &\vec{F}\_{\text{inside},j} &=& &&\frac{1}{N\_\text{vertices}}\vec{\nabla}W(\vec{v}\_c,\vec{w}_j)\\\\
    &\vec{F}\_{\text{inside},i} &=&-&&\frac{1}{N\_\text{vertices}}\vec{\nabla}W(\vec{v}\_c,\vec{w}_j)
\\end{alignat}$$

### Cycle

We introduce an additional mechanism by which the area of each cell grows linearly over time.
The growth parameter $\alpha_n$ is chosen for each cell individually from a uniform distribution.

$$\\begin{equation}
    \dot{A} = \alpha_n
\\end{equation}$$

By this process, cells will start to push on each other and thus expand the whole tissue structure.

![](/showcase/semi-vertex-model/growth.png)

## Parameters
| Parameter | Symbol | Value |
| --------- | ------ | ----- |
| Area      | $V$    | $500 \text{ µm}$ |
| Spring Tension | $\gamma$ | $2.0 \text{ µm}^{-1}\text{min}^{-1}$ |
| Central Pressure | $P$ | $0.5 \text{ µm}^{-1}\text{min}^{-2}$ |
| Interaction Range | $\beta$ | $0.5 \text{ µm}$ |
| Potential Strength | $V_0$ | $10.0 \text{ µm}^2/\text{min}^2$ |
| Damping | $\lambda$ | $0.2 \text{ min}^{-1}$ |
| Growth Rate | $\alpha$ | $5.0 \text{ µm}^2/\text{min}$ |
| Domain Size | $L$ | $800 \text{ µm}$ |
| Simulation Steps | $N_\text{step}$ | $20000$ |
| Time Increment | $\Delta t$ | $0.005 \text{ min}$ |

## Results
### Initial State

Cells are placed in a perfect hexagonal grid such that edges and vertices align.
The only distinction between the cells is their varying growth rate as described earlier.

![](/showcase/semi-vertex-model/snapshot-00000000000000000050.png)

### Movie

The cells have grown and pushed on each other thus creating small spaces in between them.

<video controls>
    <source src="/showcase/semi-vertex-model/movie.mp4">
</video>

### Final State

![](/showcase/semi-vertex-model/snapshot-00000000000000020000.png)

## Code

{{< details title="Cargo" closed="true" >}}
{{< codeFromFile
    file="cellular_raza/cellular_raza-examples/semi_vertex/Cargo.toml"
    filename="cellular_raza-examples/semi_vertex/Cargo.toml"
>}}
{{< callout type="info" >}}
The dependencies which are derived from the workspace either via `workspace = true` or
`path="../../"` should be replaced with the versions used in the workspace
[`Cargo.toml`](https://github.com/jonaspleyer/cellular_raza/tree/master/Cargo.toml).
{{< /callout >}}
{{< /details >}}
{{< details title="Cell Properties" closed="true" >}}
{{< codeFromFile
    file="cellular_raza/cellular_raza-examples/semi_vertex/src/cell_properties.rs"
    filename="cellular_raza-examples/semi_vertex/src/cell_properties.rs"
>}}
{{< /details >}}
{{< details title="Custom Domain" closed="true" >}}
{{< codeFromFile
    file="cellular_raza/cellular_raza-examples/semi_vertex/src/custom_domain.rs"
    filename="cellular_raza-examples/semi_vertex/src/custom_domain.rs"
>}}
{{< /details >}}
{{< details title="Main Simulation" closed="true" >}}
{{< codeFromFile
    file="cellular_raza/cellular_raza-examples/semi_vertex/src/main.rs"
    filename="cellular_raza-examples/semi_vertex/src/main.rs"
>}}
{{< /details >}}
{{< details title="Plotting" closed="true" >}}
{{< codeFromFile
    file="cellular_raza/cellular_raza-examples/semi_vertex/plot.py"
    filename="cellular_raza-examples/semi_vertex/plot.py"
    lang="python"
>}}
{{< /details >}}

The code for this simulation and the visualization can be found in the
[examples](https://github.com/jonaspleyer/cellular_raza/tree/master/cellular_raza-examples/semi_vertex)
folder of `cellular_raza`.

## References
[1]
R. M. H. Merks, M. Guravage, D. Inzé, and G. T. S. Beemster,
“VirtualLeaf: An Open-Source Framework for Cell-Based Modeling of Plant Tissue Growth and Development”
Plant Physiology, vol. 155, no. 2. Oxford University Press (OUP), pp. 656–666, Feb. 01, 2011.
[doi: 10.1104/pp.110.167619](https://doi.org/10.1104/pp.110.167619).

[2]
A. G. Fletcher, M. Osterfield, R. E. Baker, and S. Y. Shvartsman,
“Vertex Models of Epithelial Morphogenesis,”
Biophysical Journal, vol. 106, no. 11. Elsevier BV, pp. 2291–2304, Jun. 2014.
[doi: 10.1016/j.bpj.2013.11.4498](https://doi.org/10.1016/j.bpj.2013.11.4498).

[3]
D. L. Barton, S. Henkes, C. J. Weijer, and R. Sknepnek,
“Active Vertex Model for cell-resolution description of epithelial tissue mechanics,”
PLOS Computational Biology, vol. 13, no. 6. Public Library of Science (PLoS), p. e1005569, Jun. 30, 2017.
[doi: 10.1371/journal.pcbi.1005569](https://doi.org/10.1371/journal.pcbi.1005569).
