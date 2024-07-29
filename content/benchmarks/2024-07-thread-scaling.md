---
title: Multithreading Performance of the Cell Sorting Example (Amdahl's Law)
date: 2024-07-28
math: true
---

## Simulation Setup
One measure of multithreaded performance is to calculate the possible theoretical speedup
given by Amdahl's law [\[1\]](#references)

$$\begin{equation}
    T(n) = T_0\frac{1}{(1-p) + \frac{p}{n}}
\end{equation}$$

where $n$ is the number of used parallel threads and $p$ is the proportion of execution time which
benefits from parallelization.

Measuring the performance of any simulation will be highly dependent on the specific cellular 
properties and complexity.
To measure the performance of `cellular_raza`, we chose the cell sorting example which is the one
containing minimal complexity of all the aforementioned example simulations.
Any computational overhead which is intrinsic to `cellular_raza` and not related to the chosen
example would thus be more likely to manifest in performance results.
The total runtime of the simulation is of no relevance since we are only concerned with relative
speedup upon using additional resources.
In addition, we fixed the frequency of each processor, to circumvent power-dependent behaviour.
While it is well known that other aspects such as cache-size and memory latency can have an impact
on absolute performance, they should however not introduce any significant deviations in terms of
relative performance scaling.

## Hardware
This benchmark was run on three distinct hardware configurations.


| CPU | Fixed Clockspeed | Memory Frequency | TDP |
| --- | --- | --- | --- |
| AMD Ryzen 3700X [\[2\]](#references) | @2200MHz | 3200MT/s | 65W |
| AMD Ryzen Threadripper 3960X [\[3\]](##references) | @2000MHz | 3200MT/s | 280W |
| Intel Core i7-12700H [\[4\]](#references) | @2000MHz | 4800MT/s | 45W |

## Results

![](thread_scaling.png)

We fit equation $(1)$ and obtain the parameter $p$ from which the theoretical
maximal speedup $S$ can be calculated via

$$\begin{equation}
    S = \frac{1}{1-p}
\end{equation}$$

and thus from figure obtain the values $S_\text{3700X}=13.79$,
$S_\text{3960X}=45.05$ and $S_\text{12700H}=34.72$.

## Discussion

## References

[1]
D. P. Rodgers,
“Improvements in multiprocessor system design,”
ACM SIGARCH Computer Architecture News, vol. 13, no. 3.
Association for Computing Machinery (ACM), pp. 225–231, Jun. 1985. doi: 10.1145/327070.327215.

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
