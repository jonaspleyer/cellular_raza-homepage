---
title: Problem Size Scaling of the Cell Sorting Example
date: 2024-07-28
math: true
---

<style>
table {
    margin-left: auto;
    margin-right: auto;
    width: fit-content;
}
</style>

## Local Interactions

For interactions with infinite range the computational complexity [\[1\]](#references) of
calculating all interactions between every agent growths quadratic with the number of agents
$\mathcal{O}(N^2)$.
This can be seen when writing down the most simplistic implementation of calculating interaction
forces.

```rust
for i in 0..n_agents {
    for j in 0..i {
        // Calculate interactions between agents i and j
    }
}
```
The double for-loop iterates over all agents inside the simulation and thus results in
$N(N-1)/2=0.5(N^2-N)$ total iterations.

{{< callout type="info" >}}
All complexity-related considerations are equally valid for symmetrical and non-symmetrical
interactions.
None-symmetrical interactions (ie. $F(x_i, x_j) \neq F(x_j, x_i)$ introduce an additional constant
factor of $2$ on the computational demand but do not change the scaling behaviour.
{{< /callout >}}

`cellular_raza` was designed bottom-up with the assumption that all interactions between cellular
agents are local.
This means we can assume that a single cell interacts only with others which are within a certain
proximity defined by the type of interaction.
This behaviour allows us to [decompose](/docs/cellular_raza_concepts/trait.Domain.html) the Domain
into multiple voxels which contain cells.
The size of the voxels is determined by the length of the interaction between the cells.
This means, we only need to calculate interactions between every cell in one voxel and all
neighbouring voxels.
We assume that every voxel contains an average of $n_c$ cells per voxel with $N_v$ number of voxels
and $N_n$ number of neighbouring voxels.
The total complexity is then $\mathcal{O}(N_v n_c^2 N_n)$ where we can substitute the total number
of cells $N=N_vn_c$ to obtain

$$\begin{equation}
    \mathcal{O}(N N_n n_c).
\end{equation}$$

The parameters $N_N,n_c$ can be assumed to be constant when fixing overall cell-density or at least
capped from above and thus, we expect a linear scaling $\mathcal{O}(N)$ in the properly decomposed
approach.

This graph illustrates how interactions between cells are calculated when assuming a rectangular
decomposition scheme.

```
       │       │       │       │       │       │
───────┼───────┼───────┼───────┼───────┼───────┼──────     Interactions
       │       │    c2 │       │ c5    │       │            c1 <-> c2
       │ c1    │       │       │       │       │            c2 <-> c3
───────┼───────┼───────┼───────┼───────┼───────┼──────      c4 <-> c3
       │       │       │       │       │ c6    │            c3 <-> c5
       │       │       │   c3  │       │       │            c5 <-> c6
───────┼───────┼───────┼───────┼───────┼───────┼──────
       │       │     c4│       │       │       │
       │       │       │       │       │       │
───────┼───────┼───────┼───────┼───────┼───────┼──────
       │       │       │       │       │       │
```

## Testing Setup & Hardware

To test the expected linear scaling, we run the [cell-sorting](/showcase/cell-sorting) example for
increasing number of agents and domain size while keeping all other parameters identical.
Every simulation run was performed utilizing just one thread and 5 samples were taken per datapoint.
To validate our results, we tested 3 distinct hardware configurations shown in [Table 1](#hardware).
These resemble setups for a higher-end laptop [\[2\]](#references), a performance-oriented
workstation [\[3\]](#references) and a regular desktop [\[4\]](#references)

| CPU | Fixed Clockspeed | Memory Frequency | TDP |
| --- | --- | --- | --- |
| Intel Core i7-12700H [\[2\]](#references) | @2000MHz | 4800MT/s | 45W |
| AMD Ryzen Threadripper 3960X [\[3\]](##references) | @2000MHz | 3200MT/s | 280W |
| AMD Ryzen 3700X [\[4\]](#references) | @2200MHz | 3200MT/s | 65W |

<br>
<div style="text-align: center">
    <p>Table 1: Overview of the tested hardware configurations</p>
</div>
<br>

To quantitatively assess if the expected scaling of $\mathcal{O}(N)$ is satisfied, we fit a
quadratic curve of the form

$$\begin{equation}
    R(N) = p_2N^2 + p_1N + p_0
\end{equation}$$

with non-negative parameters $p_i$ to the generated performance results.
We then calculate the individual contributions of the terms and compare them at all measured points.

$$\begin{align}
    c_2 &= p_2N^2\\\\
    c_1 &= p_1N\\\\
    c_0 &= p_0
\end{align}$$

Our hypothesis of $\mathcal{O}(N)$ scaling will hold true of any contributions of second-order are
negligible compared to the first-order.
However, it is clear that with increasing the number of agents $N$, we expect the second-order
contribution to gain in relevance as well.
Furthermore, we can not rule out constant contributions $c_0$ due to fixed computational costs in
creating and stopping the simulation although we exptect these contributions to be of neglibile
magnitude compared to the computational overhead of calculating interactions.
In addition, we also compare the estimated value of the parameter $p_2$ with the null-hypothesis
$0$ using the calculated variance $\sigma_2$ obtained by the fitting algorithm.

## Results

[Figure 1](#results) shows a double-logarithmic plot of the calculated runtimes with their fits.
[Table 2](#results) displays the calculated parameters of the quadratic formula in
[equation $(2)$](#testing-setup--hardware).

![](/benchmarks/sim-size-scaling.png)

<div style="text-align: center;">
    <p>Figure 1: Performance results for increasing problem sizes.</p>
</div>

| Processor | $p_2$                    | $p_1$                 | $p_0$                  |
| --------- | ------------------------ |---------------------- | ---------------------- |
| 12700H    | $1.294\times 10^{-25}$   | $5.050\times 10^{-5}$ | $4.562\times 10^{-2}$  |
| 3960X     | $4.346\times 10^{-14}$   | $5.267\times 10^{-5}$ | $5.072\times 10^{-16}$ |
| 3700X     | $3.010\times 10^{-12}$   | $5.067\times 10^{-5}$ | $2.014\times 10^{-10}$ |

<br>
<div style="text-align: center;">
    <p>Table 2: Fit parameters for quadratic approximation of scaling behaviour.</p>
</div>

Our hypothesis that the second-order contribution $c_2 = p_2 N^2$ is much smaller than the
first-order $c_1 = p_1 N$ is confirmed by comparing at every measured datapoint.
The largest contributions of $c_2$ occur at the last measured datapoint and are negligible for
setups [\[2\]](#references) and [\[3\]](#references).
Setup [\[4\]](#references) shows a larger contribution at its last respective datapoint.
The obtained results show deviations of
$1.098\times 10^{-13}\sigma_2$ for setup [\[2\]](#references),
$1.838\times 10^{0}\sigma_2$ for setup [\[3\]](#references) and
$7.199\times 10^{0}\sigma_2$ for setup [\[4\]](#references) to the null-hypothesis of $p_2=0$.
The first two results are within the $3\sigma_2$ interval of the exptected value while the last
setup does show a difference.
However, we also saw deviations from expected results when testing the
[multithreading performance](/benchmarks/2024-07-thread-scaling) with this setup.

```bash
=============================================
| Fitting summary for 12700H @2GHz with polynomial of order 2
|--------------------------------------------
| Coefficients:  p2=1.294e-25 p1=5.050e-05 p0=4.562e-02
| Variance:      s2=1.179e-12 s1=1.561e-06 s0=1.536e-01
| Effects at n_agents=327680:
| Contribution at n_agents=        80:  c2=8.2806e-22 c1=4.0397e-03 c0=4.5615e-02
| Relative                              r2=      0.0% r1=      8.1% r0=     91.9%
| Contribution at n_agents=       320:  c2=1.3249e-20 c1=1.6159e-02 c0=4.5615e-02
| Relative                              r2=      0.0% r1=     26.2% r0=     73.8%
| Contribution at n_agents=      1280:  c2=2.1198e-19 c1=6.4636e-02 c0=4.5615e-02
| Relative                              r2=      0.0% r1=     58.6% r0=     41.4%
| Contribution at n_agents=      5120:  c2=3.3917e-18 c1=2.5854e-01 c0=4.5615e-02
| Relative                              r2=      0.0% r1=     85.0% r0=     15.0%
| Contribution at n_agents=     20480:  c2=5.4268e-17 c1=1.0342e+00 c0=4.5615e-02
| Relative                              r2=      0.0% r1=     95.8% r0=      4.2%
| Contribution at n_agents=     81920:  c2=8.6829e-16 c1=4.1367e+00 c0=4.5615e-02
| Relative                              r2=      0.0% r1=     98.9% r0=      1.1%
| Contribution at n_agents=    327680:  c2=1.3893e-14 c1=1.6547e+01 c0=4.5615e-02
| Relative                              r2=      0.0% r1=     99.7% r0=      0.3%
| Contribution at n_agents=   1310720:  c2=2.2228e-13 c1=6.6187e+01 c0=4.5615e-02
| Relative                              r2=      0.0% r1=     99.9% r0=      0.1%
=============================================
| Fitting summary for 3960X @2GHz with polynomial of order 2
|--------------------------------------------
| Coefficients:  p2=4.346e-14 p1=5.276e-05 p0=5.072e-16
| Variance:      s2=2.365e-14 s1=4.963e-07 s0=6.876e-01
| Effects at n_agents=5242880:
| Contribution at n_agents=        80:  c2=2.7813e-10 c1=4.2210e-03 c0=5.0725e-16
| Relative                              r2=      0.0% r1=    100.0% r0=      0.0%
| Contribution at n_agents=       320:  c2=4.4501e-09 c1=1.6884e-02 c0=5.0725e-16
| Relative                              r2=      0.0% r1=    100.0% r0=      0.0%
| Contribution at n_agents=      1280:  c2=7.1201e-08 c1=6.7537e-02 c0=5.0725e-16
| Relative                              r2=      0.0% r1=    100.0% r0=      0.0%
| Contribution at n_agents=      5120:  c2=1.1392e-06 c1=2.7015e-01 c0=5.0725e-16
| Relative                              r2=      0.0% r1=    100.0% r0=      0.0%
| Contribution at n_agents=     20480:  c2=1.8228e-05 c1=1.0806e+00 c0=5.0725e-16
| Relative                              r2=      0.0% r1=    100.0% r0=      0.0%
| Contribution at n_agents=     81920:  c2=2.9164e-04 c1=4.3223e+00 c0=5.0725e-16
| Relative                              r2=      0.0% r1=    100.0% r0=      0.0%
| Contribution at n_agents=    327680:  c2=4.6662e-03 c1=1.7289e+01 c0=5.0725e-16
| Relative                              r2=      0.0% r1=    100.0% r0=      0.0%
| Contribution at n_agents=   1310720:  c2=7.4660e-02 c1=6.9157e+01 c0=5.0725e-16
| Relative                              r2=      0.1% r1=     99.9% r0=      0.0%
| Contribution at n_agents=   5242880:  c2=1.1946e+00 c1=2.7663e+02 c0=5.0725e-16
| Relative                              r2=      0.4% r1=     99.6% r0=      0.0%
| Contribution at n_agents=  20971520:  c2=1.9113e+01 c1=1.1065e+03 c0=5.0725e-16
| Relative                              r2=      1.7% r1=     98.3% r0=      0.0%
=============================================
| Fitting summary for 3700X @2GHz with polynomial of order 2
|--------------------------------------------
| Coefficients:  p2=3.010e-12 p1=5.067e-05 p0=2.014e-10
| Variance:      s2=4.181e-13 s1=5.536e-07 s0=5.447e-02
| Effects at n_agents=327680:
| Contribution at n_agents=        80:  c2=1.9262e-08 c1=4.0533e-03 c0=2.0135e-10
| Relative                              r2=      0.0% r1=    100.0% r0=      0.0%
| Contribution at n_agents=       320:  c2=3.0818e-07 c1=1.6213e-02 c0=2.0135e-10
| Relative                              r2=      0.0% r1=    100.0% r0=      0.0%
| Contribution at n_agents=      1280:  c2=4.9310e-06 c1=6.4853e-02 c0=2.0135e-10
| Relative                              r2=      0.0% r1=    100.0% r0=      0.0%
| Contribution at n_agents=      5120:  c2=7.8895e-05 c1=2.5941e-01 c0=2.0135e-10
| Relative                              r2=      0.0% r1=    100.0% r0=      0.0%
| Contribution at n_agents=     20480:  c2=1.2623e-03 c1=1.0376e+00 c0=2.0135e-10
| Relative                              r2=      0.1% r1=     99.9% r0=      0.0%
| Contribution at n_agents=     81920:  c2=2.0197e-02 c1=4.1506e+00 c0=2.0135e-10
| Relative                              r2=      0.5% r1=     99.5% r0=      0.0%
| Contribution at n_agents=    327680:  c2=3.2316e-01 c1=1.6602e+01 c0=2.0135e-10
| Relative                              r2=      1.9% r1=     98.1% r0=      0.0%
| Contribution at n_agents=   1310720:  c2=5.1705e+00 c1=6.6409e+01 c0=2.0135e-10
| Relative                              r2=      7.2% r1=     92.8% r0=      0.0%
```

## Discussion

We have shown that the implemented
[domain decomposition](/docs/cellular_raza_concepts/trait.Domain.html) of `cellular_raza` behaves
as exptected and delivers a $\mathcal{O}(N)$ linear scaling in terms of total problem size.
The absolute performance affecting the total runtime of each simulation is highly dependent on the
specified cellular interactions.
However, this will not change the shape of the calculated curve but rather only its slope.

One important effect in measuring the runtime is cache-size of the respective processor and size of
the simulation.
Modern processors contain multiple levels of caches (L1, L2, L3) in order to store intermediate
values and speed up computations.
If a larger chunk of agents is able to fit inside the lower levels of cache, this will greatly
improve runtime performance.

Another influence could result from context-switches and interrupts by the scheduler of the
underlying operating system [\[5\]](#references).
These operations break the execution of the program and thus introduce further overhead.
The number of interrupts and context-switches can be estimated to be proportional ot the execution
time and introduces an overhead proportional to the total amount of these events.

In the [cell-sorting](/showcase/cell-sorting) example we combined multiple components of
`cellular_raza` such as the decomposition method implemented by the
[`CartesianCuboid3`](/docs/cellular_raza_building_blocks/struct.CartesianCuboid3New.html) struct and
the solving components used by the [chili](/internals/backends/chili) backend.
Of these two choices, the domain decomposition will affect calculated results most significantly.
We expect that a hexagonal decomposition in the two-dimensional case will lead superior results
due to a reduced number of only $6$ neighbours compared to the cuboid approaches $8$ neighbouring
voxels.

Linear scaling with the number of agents (considering a fixed density) is highly relevant in order
to further develop the existing tool and make it properly suitable for HPC solutions and to run
large-scale simulations.
Other recently developed tools [\[6,7\]](#references) do not exhibit this behaviour and will thus
require exponentially more computational time with linearly increasing problem size.

## References

[1]
D. E. Knuth, “Big Omicron and big Omega and big Theta,”
ACM SIGACT News, vol. 8, no. 2. Association for Computing Machinery (ACM), pp. 18–24, Apr. 1976.
doi: [10.1145/1008328.1008329](https://doi.org/10.1145/1008328.1008329).

[2]
Intel® Core™ i7-12700H Processor.
[Online].
Available: https://ark.intel.com/content/www/us/en/ark/products/132228/intel-core-i7-12700h-processor-24m-cache-up-to-4-70-ghz.html

[3]
AMD Ryzen™ Threadripper™ 3960X Drivers & Support.
[Online].
Available: https://www.amd.com/en/support/downloads/drivers.html/processors/ryzen-threadripper/ryzen-threadripper-3000-series/amd-ryzen-threadripper-3960x.html

[4]
AMD Ryzen™ 7 3700X.
[Online].
Available: https://www.amd.com/en/product/8446

[5]
F. M. David, J. C. Carlyle, and R. H. Campbell,
“Context switch overheads for Linux on ARM platforms,”
Proceedings of the 2007 workshop on Experimental computer science. ACM, Jun. 13, 2007.
doi: [10.1145/1281700.1281703](https://doi.org/10.1145/1281700.1281703).

[6]
C. Borau, R. Chisholm, P. Richmond, and D. Walker,
“An agent-based model for cell microenvironment simulation using FLAMEGPU2,”
Computers in Biology and Medicine, vol. 179. Elsevier BV, p. 108831,
Sep. 2024. doi:
[10.1016/j.compbiomed.2024.108831](https://doi.org/10.1016/j.compbiomed.2024.108831).

[7]
R. Vetter, S. V. M. Runser, and D. Iber,
“PolyHoop: Soft particle and tissue dynamics with topological transitions,”
Computer Physics Communications, vol. 299, p. 109128, Jun. 2024,
doi: [10.1016/j.cpc.2024.109128](https://doi.org/10.1016/j.cpc.2024.109128).
