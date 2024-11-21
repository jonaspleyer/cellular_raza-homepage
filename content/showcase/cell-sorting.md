---
title: 3D Cell Sorting
date: 2024-01-10
math: true
---

Cell Sorting is a naturally occuring phenomenon which drives many biological processes
[\[1,2\]](#references).
While the underlying biological reality can be quite complex, it is rather simple to describe such
a system in its most basic form.
The underlying principle is that interactions between cells are specific.

## Mathematical Description

We assume that cells are spherical objects which interact via force potentials.
The two positions of cells are $x_i,x_j$ and their distance is $r=|x_i-x_j|$.

$$\begin{align}
    \sigma_{i,j} &= \frac{r}{R_i + R_j}\\\\
    U(\sigma_{i,j}) &= V_0 \left(\frac{1}{3\sigma\_{i,j}^3} - \frac{1}{\sigma_{i,j}}\right)
\end{align}$$

The values $R_i,R_j$ are the radii of the cells ($i\neq j$) interacting with each other.
For simplification, we can assume that they are identical $R_i=R_j=R$.

Furthermore, we assume that the equation of motion is given by

$$\begin{equation}
    \partial^2_t x = F - \lambda \partial_t x
\end{equation}$$

where the first term is the usual force term $F = - \nabla V$ obtained by differentiating the
given potential and the second term is a damping term which arises due to the cells being immersed
inside a viscuous fluid.

{{< callout type="info" >}}
Note that we set the mass to $m=1$ thus rescaling the involved parameters.
This means, that units of $V_0$ and $\lambda$ are changing and they incorporate this property.
{{< /callout >}}

We can assume that interactions between cells are restricted to close ranges and thus enforce a
cutoff $\xi\geq R_i+R_j$ for the interaction where the resulting force is identical to zero.
We further assume that cells of different species do not attract each other but do repel.
To describe this behaviour, we set the potential to zero when $r>R_i+R_j$ (i.e., $\sigma_{i,j}>1$)
and both cells have distinct species type $s_i$.
In total we are left with

$$\begin{equation}
    V(\sigma_{i,j}) =
    \begin{cases}
        0 &\text{ if } \sigma_{i,j}\geq\xi/(R_i+R_j)\\\\
        0 &\text{ if } s_i\neq s_j \text{ and } \sigma_{i,j}\geq 1\\\\
        U(\sigma_{i,j}) &\text{ else }
    \end{cases}.
\end{equation}$$

## Parameters

In total, we are left with only 4 parameters to describe our system.

| Parameter | Symbol | Value |
| --- | --- | --- |
| Cell Radius | $R_i$ | $6.0 \text{ µm}$ |
| Potential Strength | $V_0$ | $2\text{ µm}^2\text{ }/\text{ min}^2$ |
| Damping Constant | $\lambda$ | $2\text{min}^{-1}$ |
| Interaction Range | $\xi$ | $1.5 (R_i+R_j)=3R_i$ |

The following table shows additional values which are used to initialize the system.
In total, 1600 cells with random initial positions and zero velocity were placed inside the domain.

| Property | Symbol | Value |
| --- | --- | --- |
| Time Stepsize | $\Delta t$ | $0.2\text{min}$ |
| Time Steps | $N_t$ | $10'000$ |
| Domain Size | $L$ | $110\text{ µm}$ |
| Cells Species 1 | $N_{C,1}$ | $800$ |
| Cells Species 2 | $N_{C,2}$ | $800$ |

The chosen total simulated time is thus $2000\text{ min}=33.33\text{ h}$.

## Results

### Initial State

Cells are initially placed randomly inside the cuboid simulation domain.

![](/showcase/cell_sorting/0000000020.png)

### Movie

<video controls>
    <source src="/showcase/cell_sorting/movie.mp4" type="video/mp4">
</video>

### Final State

After the simulation has finished, the cells have assembled into connected regions of the same
species.

![](/showcase/cell_sorting/0000010000.png)

## Code

The code for this simulation and the visualization can be found in the
[examples](https://github.com/jonaspleyer/cellular_raza/tree/master/cellular_raza-examples/cell_sorting)
folder of `cellular_raza`.

{{< details title="Full Code" closed="true" >}}
{{< codeFromFile
    file="cellular_raza/cellular_raza-examples/cell_sorting/src/main.rs"
    filename="cellular_raza-examples/cell_sorting/src/main.rs"
>}}
{{< /details >}}

## References

[1] M. S. Steinberg,
“Reconstruction of Tissues by Dissociated Cells,”
Science, vol. 141, no. 3579.
American Association for the Advancement of Science (AAAS),
pp. 401–408, Aug. 02, 1963.
doi: [10.1126/science.141.3579.401](https://doi.org/10.1126/science.141.3579.401).

[2] F. Graner and J. A. Glazier,
“Simulation of biological cell sorting using a two-dimensional extended Potts model,”
Physical Review Letters, vol. 69, no. 13.
American Physical Society (APS),
pp. 2013–2016, Sep. 28, 1992.
doi: [10.1103/physrevlett.69.2013](https://doi.org/10.1103/physrevlett.69.2013).
