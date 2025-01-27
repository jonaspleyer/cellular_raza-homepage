---
title: Multithreading Performance of the Cell Sorting Example (Amdahl's Law)
date: 2024-07-20
math: true
---

## Theory
One measure of multithreaded performance is to calculate the possible theoretical speedup
given by Amdahl's law [\[1\]](#references).
It provides an estimate for the speedup and assumes that the workload can be split into a
parallelizable and non-parallelizable part which is quantified by $0\leq p \leq1$.
A higher value means that the contribution coming from non-parallelizable algorithms is lower.

$$\begin{equation}
    T(n) = T_0\frac{1}{(1-p) + \frac{p}{n}}
\end{equation}$$

Here, $n$ is the number of used parallel threads and $p$ is the proportion of execution time which
benefits from parallelization.

## Simulation Setup
Measuring the performance of any simulation will be highly dependent on the specific cellular 
properties and complexity.
For this comparison, we chose the [cell-sorting](/showcase/cell-sorting) example which contains
minimal complexity compared to the remaining [showcases](/showcase).
Any computational overhead which is intrinsic to `cellular_raza` and not related to the chosen
example would thus be more likely to manifest itself in performance results.
The total runtime of the simulation is of no relevance since we are only concerned with relative
speedup upon using additional resources.
The
[`cellular_raza-benchmarks`](https://github.com/jonaspleyer/cellular_raza/cellular_raza-benchmarks)
crate is a command-line utility which can be used to run benchmarks with various configurations.
```bash
# cd cellular_raza-benchmarks
# cargo run -- -h
cellular_raza benchmarks

Usage: cell_sorting [OPTIONS] <NAME> [COMMAND]

Commands:
  threads   Thread scaling benchmark
  sim-size  Simulation Size scaling benchmark
  help      Print this message or the help of the given subcommand(s)

Arguments:
  <NAME>  Name of the current runs such as name of the device to be benchmarked

Options:
  -o, --output-directory <OUTPUT_DIRECTORY>
          Output directory of benchmark results [default: benchmark_results]
  -s, --sample-size <SAMPLE_SIZE>
          Number of samples to be generated for each measurement [default: 5]
      --no-save
          Do not save results. This takes priority against the overwrite settings
      --overwrite
          Overwrite existing results
      --no-output
          Disables output
  -h, --help
          Print help
  -V, --version
          Print version

```
Results generated in this way are stored inside the `benchmark_results` folder.
In addition, we provide a python script `plotting/cell_sorting.py` to quickly visualize obtained
results.

## Hardware
This benchmark was run on three distinct hardware configurations.
In order to produce reliable benchmarks, in principle we would have to control a wide range of
variables or at least test their configurations.
However, we expect that the biggest effect will be produced by the power-limits and frequency of
the respective hardware.
Both of these effects can be circumvented by choosing a artificial fixed frequency which is low
enough such that the total power limit of the CPU is never reached.
In addition, we fixed the frequency of each processor, to circumvent power-dependent behaviour.
While it is well known that other aspects such as cache-size and memory latency can have an impact
on absolute performance, they should however not introduce any significant deviations in terms of
relative performance scaling.

| CPU | Fixed Clockspeed | Memory Frequency | TDP |
| --- | --- | --- | --- |
| AMD Ryzen 3700X [\[2\]](#references) | @2200MHz | 3200MT/s | 65W |
| AMD Ryzen Threadripper 3960X [\[3\]](##references) | @2000MHz | 3200MT/s | 280W |
| Intel Core i7-12700H [\[4\]](#references) | @2000MHz | 4800MT/s | 45W |

<br>
<div style="text-align: center;">
    <p>Table 1: List of tested hardware configurations.</p>
</div>

## Results

![](thread_scaling.png)

<br>
<div style="text-align: center;">
    <p>Figure 1: Performance results for increasing number of utilized threads.</p>
</div>

We fit [equation $(1)$](#theory) and obtain the parameter $p$ from which the theoretical
maximal speedup $S$ can be calculated via

$$\begin{equation}
    S = \frac{1}{1-p}
\end{equation}$$

and thus from figure obtain the values $S_\text{3700X}=13.64\pm1.73$,
$S_\text{3960X}=44.99\pm2.80$ and $S_\text{12700H}=34.74\pm5.05$.
The uncertainty $\sigma(S)$ is calculated via the standard gaussian propagation

$$\begin{equation}
    \sigma(S) = \frac{\sigma(p)}{(1-p)^2}
\end{equation}$$

where we obtained $\sigma(p)$ from the fit above.

## Discussion
The perfect score of a fully parallelizable system with $p=1$ is considered almost unattainable
in a real-world scenario where effects such as the workload of the underlying operating system
and physical constraints make it hard to achieve this value.
In practice, the value measured here does also depend on the respective hardware.

In addition to hardware-related influences, we also expect a portion of $1-p$ our simulation code
to be fundamentally not parallelizable.
This fraction can be made up of the initial setup of the simulation which necessarily has to start single-threaded and can only extend to multiple processes once all respective
[subdomains](/internals/concepts/domain/decomposition) have been
[generated](/docs/cellular_raza_concepts/trait.DomainCreateSubDomains.html).
Furthermore, stopping the simulation frees resources after combining all threads again.
Even more importantly, all threads are currently using a
[`Barrier`](/docs/cellular_raza_core/backend/chili/struct.BarrierSync.html) to sync with each
other.
This also creates a dependency and introduces overhead.

The total speedup $S$ is still very good for all configurations which can be directly attributed
to the core assumption of `cellular_raza` that
[all interactions are strictly local](/guides/introduction/#local-rules) and subdomains are only
interacting along their borders without the need to construct complex long-ranging
synchronization algorithms.

## References

[1]
D. P. Rodgers,
“Improvements in multiprocessor system design,”
ACM SIGARCH Computer Architecture News, vol. 13, no. 3.
Association for Computing Machinery (ACM), pp. 225–231, Jun. 1985.
[doi: 10.1145/327070.327215](https://doi.org/10.1145/327070.327215).

[2]
AMD Ryzen™ 7 3700X.
[Online].
Available: https://www.amd.com/en/product/8446

[3]
AMD Ryzen™ Threadripper™ 3960X Drivers & Support.
[Online].
Available: https://www.amd.com/en/support/downloads/drivers.html/processors/ryzen-threadripper/ryzen-threadripper-3000-series/amd-ryzen-threadripper-3960x.html

[4]
Intel® Core™ i7-12700H Processor.
[Online].
Available: https://ark.intel.com/content/www/us/en/ark/products/132228/intel-core-i7-12700h-processor-24m-cache-up-to-4-70-ghz.html
