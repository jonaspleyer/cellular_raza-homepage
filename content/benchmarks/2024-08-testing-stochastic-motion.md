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

## Code

To run the supplied test navigate to the `cellular_raza` folder containing the bundle of all
dependencies and execute the tests in release mode.

```bash
git clone https://github.com/jonaspleyer/cellular_raza
cd cellular_raza/cellular_raza
cargo test -r
```

This will generate results stored in json format in the `out` directory.
To visualize the results, use the provided [script](#plotScript).


{{< details title="Set up Parameters and Settings" closed="true" >}}
{{<
    codeFromFile
    file="cellular_raza/cellular_raza/tests/brownian_diffusion_constant_approx.rs"
    start="1"
    end="69"
>}}
{{< /details >}}

{{<
    codeFromFile
    file="cellular_raza/cellular_raza/tests/brownian_diffusion_constant_approx.rs"
    start="71"
    end="107"
>}}

{{<
    codeFromFile
    file="cellular_raza/cellular_raza/tests/brownian_diffusion_constant_approx.rs"
    start="109"
    end="123"
>}}

{{<
    codeFromFile
    file="cellular_raza/cellular_raza/tests/brownian_diffusion_constant_approx.rs"
    start="135"
    end="168"
>}}

{{<
    codeFromFile
    file="cellular_raza/cellular_raza/tests/brownian_diffusion_constant_approx.rs"
    start="170"
    end="178"
>}}

{{< details title="Compare Langevin Results" closed="true" >}}
{{<
    codeFromFile
    file="cellular_raza/cellular_raza/tests/brownian_diffusion_constant_approx.rs"
    start="267"
    end="297"
>}}
{{< /details >}}

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

<div id="plotScript">
{{< details title="Script to plot results" closed="true" >}}
{{<
    codeFromFile
    file="cellular_raza/cellular_raza/tests/plot_brownian_langevin.py"
    lang="python"
>}}
{{< /details >}}
</div>

## Results

## Discussion

## References


