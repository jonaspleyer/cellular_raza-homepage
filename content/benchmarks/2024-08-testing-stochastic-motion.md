---
title: "Testing Stochastic Motion via the Fluctuation-Dissipation Theorem"
date: 2024-08-24
math: true
---

## Theory

Stochastic motion on a particle level is often well described by
[`Brownian3D`](/docs/cellular_raza_building_blocks/struct.Brownian3D.html) or
[`Langevin3D`](/docs/cellular_raza_building_blocks/struct.Langevin3D.html) dynamics
[\[1,2\]](#references).
The [Fluctuation-Dissipation theorem](https://en.wikipedia.org/wiki/Fluctuation-dissipation_theorem)
[\[3\]](#references) gives estimates the for mean squared displacement (MSD) of a collection of
such particles and can thus be used to test the numerical implementation.

### Brownian Dynamics

In the case of
[`Brownian3D`](/docs/cellular_raza_building_blocks/struct.Brownian3D.html) dynamics

$$\\begin{equation}
    \dot{X} = -\frac{D}{k_B T} \nabla V(X) + \sqrt{2D}R(t),
\\end{equation}$$

Einstein predicted that the diffusion constant is proportional to the particles mobility
[\[4\]](#references).
The MSD can be derived by applying the FDT to the probability density function (PDF) of a brownian
particle

$$\\begin{equation}
    P(x,t) = \\frac{1}{\\sqrt{4\\pi D t}}\exp\left(-\\frac{(x-x_0)^2}{4Dt}\right).
\\end{equation}$$

By calculating the fourier transform, we obtain the characteristic function

$$\\begin{equation}
    G(k) = \\int \text{e}^{ikx} P(x,t|x0)dx = \text{exp}(ikx_0 - k^2Dt).
\\end{equation}$$

We obtain the moments by differentiating the characteristic function
$\\kappa_n = (-i)^n\\partial_k^n G(k)|_{k=0}$.

$$\\begin{align}
    \\kappa_1 &= x_0\\\\
    \\kappa_2 &= 2Dt
\\end{align}$$

For more than one spatial dimension, this approach can be generalized and we obtain

$$\\begin{equation}
    \left<r^2(t)\right> = 2d D t
\\end{equation}$$

where $d$ is the number of spatial dimensions of our system.

### Langevin Dynamics

The estimate of the MSD for
[`Langevin3D`](/docs/cellular_raza_building_blocks/struct.Langevin3D.html) dynamics

$$\\begin{equation}
    M \ddot{X} = - \nabla V(X) - \lambda M \dot{X} + \sqrt{2M\lambda k_B T}R(t)
\\end{equation}$$

is given by [\[5\]](#references)

$$\\begin{equation}
    \left<r^2(t)\right> =
        v^2(0) \frac{1-\text{e}^{-\lambda t}}{\lambda^2}
        - \frac{d k_B T}{m\lambda^2}
            \left(1-\text{e}^{-\lambda t}\right)
            \left(3 - \text{e}^{-\lambda t}\right)
        + \frac{2 d k_B T}{m\lambda}t.
\\end{equation}$$

It is now a matter of writing code such that the described system can be solved, analyzed and
tested.

## Code

First, we define methods, to initialize the agents and set up the simulation parameters.

{{<
    codeFromFile
    file="cellular_raza/cellular_raza/tests/brownian_diffusion_constant_approx.rs"
    start="8"
    end="37"
>}}

We specifically require that results are only stored on the disk (in json format) if
`#[cfg(not(debug_assertions))]`.
This is usually the case when running in release mode.

{{< details title="Define settings" closed="true" >}}
{{<
    codeFromFile
    file="cellular_raza/cellular_raza/tests/brownian_diffusion_constant_approx.rs"
    start="39"
    end="69"
>}}
{{< /details >}}

{{< details title="Calculate mean and standard deviation" closed="true" >}}
{{<
    codeFromFile
    file="cellular_raza/cellular_raza/tests/brownian_diffusion_constant_approx.rs"
    start="71"
    end="107"
>}}
{{< /details >}}

In order to test our numerical results, we compare the mean squared displacement at every iteration
with the analytical estimate.
Their difference should be within the margin of multiple $\\sigma$ of each other.
This method of testing will be valid for the chosen set of parameters.
Should a future code refactor (which does not affect the tests) produce different results, this test
will only fail when results are not in the specified confidence region.
For our chosen threshold of $3.5\\sigma$, the probability for any result to be outside this band is
$p=0.0465\\%$.

### Brownian

{{<
    codeFromFile
    file="cellular_raza/cellular_raza/tests/brownian_diffusion_constant_approx.rs"
    start="109"
    end="123"
>}}

We now combine all functionalities in the `test_brownian!` macro.
Every agent, is positioned in the middle of the simulation domain with no initial velocity
(irrelevant for the Brownian case).
We have chosen the domain size such that no agent reaches the outer boundary which change the MSD.

{{< details title="Combine previously defined functions with macro" closed="true" >}}
{{<
    codeFromFile
    file="cellular_raza/cellular_raza/tests/brownian_diffusion_constant_approx.rs"
    start="125"
    end="168"
>}}
{{< /details >}}

This macro can afterwards be used in a collection of multiple functions to test various
parameter configurations.

{{<
    codeFromFile
    file="cellular_raza/cellular_raza/tests/brownian_diffusion_constant_approx.rs"
    start="170"
    end="178"
>}}

### Langevin

Since the langevin equation introduces fluctuations for the velocity of the particle, the first
integration step does not change the position.
Thus we skip the initial step when comparing results.

{{<
    codeFromFile
    file="cellular_raza/cellular_raza/tests/brownian_diffusion_constant_approx.rs"
    start="260"
    end="288"
>}}

{{< details title="Macro to compare Langevin Results" closed="true" >}}
{{<
    codeFromFile
    file="cellular_raza/cellular_raza/tests/brownian_diffusion_constant_approx.rs"
    start="299"
    end="349"
>}}
{{< /details >}}

{{< details title="Example Test For Langevin Results" closed="true" >}}
{{<
    codeFromFile
    file="cellular_raza/cellular_raza/tests/brownian_diffusion_constant_approx.rs"
    start="351"
    end="358"
>}}
{{< /details >}}

### Running the Tests

To run the supplied test navigate to the `cellular_raza` folder containing the bundle of all
dependencies and execute the tests in release mode.

```bash
git clone https://github.com/jonaspleyer/cellular_raza
cd cellular_raza/cellular_raza
cargo test -r

# For visualization
python tests/plot_brownian_langevin.py
```

This will generate results stored in json format in the `out` directory.
To visualize the results, use the provided python script.
It requires `matplotlib`,`numpy` and `scipy` as dependencies.

{{< details title="Script to plot results" closed="true" >}}
{{<
    codeFromFile
    file="cellular_raza/cellular_raza/tests/plot_brownian_langevin.py"
    lang="python"
>}}
{{< /details >}}


## Results

<div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(300px, 1fr)); column-gap: 1em;">
    <div>
        <p style="text-align: center; font-size: 1.5em;">Brownian Results</p>
        <img
            src="/benchmarks/2024-08-testing-stochastic-motion/brownian_2d_3/mean-squared-displacement.png"
            style="display: inline;"
        >
        <img
            src="/benchmarks/2024-08-testing-stochastic-motion/brownian_2d_3/trajectories.png"
            style="display: inline;"
        >
        <img
            src="/benchmarks/2024-08-testing-stochastic-motion/brownian_2d_3/heatmap.png"
            style="display: inline;"
        >
    </div>
    <div style="text-align: center; font-size: 1.5em;">
        Langevin Results
        <img
            src="/benchmarks/2024-08-testing-stochastic-motion/langevin_2d_4/mean-squared-displacement.png"
            style="display: inline;"
        >
        <img
            src="/benchmarks/2024-08-testing-stochastic-motion/langevin_2d_4/trajectories.png"
            style="display: inline;"
        >
        <img
            src="/benchmarks/2024-08-testing-stochastic-motion/langevin_2d_4/heatmap.png"
            style="display: inline;"
        >
    </div>
</div>

{{< callout type="info" >}}
Note that the displayed errorbars are not identical to the ones used for automated testing.
We plot the standard error $\sigma / \sqrt{N}$ while the standard deviation $\sigma$ is used to
compare numerical results.
{{< /callout >}}

The figures above show results for the brownian and langevin cases.
We first compare the MSD with its predicted values and obtain parameters by fitting the predictor
to our simulated values.
In the second plots, all trajectories of all particles are shown.
We can clearly see that the motions in the Brownian case are much more fluctuating while the curves
of the Langevin case are more smooth although this behaviour depends on the chosen parameters.
In the last step, a heatmap is shown which counts the number of times each bin is visited by a
particle.

## Discussion

In practice, our testing scheme is most sensitive in the early stages of simulation since the
deviation of the MSD is lowest at this point in time.
This is a practical challenge since the initial steps of the solver are
[less accurate](/internals/backends/chili/solvers) and thus the overall uncertainty of the
numerically obtained results.

## References

[1]
D. S. Lemons and A. Gythiel,
“Paul Langevin’s 1908 paper ‘On the Theory of Brownian Motion’
[‘Sur la théorie du mouvement brownien,’ C. R. Acad. Sci. (Paris) 146, 530–533 (1908)],”
American Journal of Physics, vol. 65, no. 11.
American Association of Physics Teachers (AAPT), pp. 1079–1081, Nov. 01, 1997.
[doi: 10.1119/1.18725](https://doi.org/10.1119/1.18725).

[2]
R. Brown, “XXVII.
A brief account of microscopical observations made in the months of June,
July and August 1827,
on the particles contained in the pollen of plants;
and on the general existence of active molecules in organic and inorganic bodies,”
The Philosophical Magazine, vol. 4, no. 21.
Informa UK Limited, pp. 161–173, Sep. 1828.
[doi: 10.1080/14786442808674769](https://doi.org/10.1080/14786442808674769).

[3]
H. B. Callen and T. A. Welton,
“Irreversibility and Generalized Noise,”
Physical Review, vol. 83, no. 1.
American Physical Society (APS), pp. 34–40, Jul. 01, 1951.
[doi: 10.1103/physrev.83.34](https://doi.org/10.1103%2FPhysRev.83.34).

[4]
A. Einstein,
“Über die von der molekularkinetischen Theorie der Wärme geforderte Bewegung von in ruhenden
Flüssigkeiten suspendierten Teilchen,”
Annalen der Physik, vol. 322, no. 8.
Wiley, pp. 549–560, Jan. 1905.
[doi: 10.1002/andp.19053220806](https://doi.org/10.1002%2Fandp.19053220806).

[5]
N. G. VAN KAMPEN,
“THE LANGEVIN APPROACH,”
Stochastic Processes in Physics and Chemistry.
Elsevier, pp. 219–243, 2007.
[doi: 10.1016/b978-044452965-7/50012-x](https://doi.org/10.1016/B978-044452965-7/50012-X).
