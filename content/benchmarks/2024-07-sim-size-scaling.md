---
title: Problem Size Scaling of the Cell Sorting Example
date: 2024-07-28
math: true
---

## Theory

$$\begin{equation}
    f(x) = a + bx + cx^2
\end{equation}$$

## Simulation Setup

## Hardware

| CPU | Fixed Clockspeed | Memory Frequency | TDP |
| --- | --- | --- | --- |
| Intel Core i7-12700H [\[2\]](#references) | @2000MHz | 4800MT/s | 45W |
| AMD Ryzen Threadripper 3960X [\[3\]](##references) | @2000MHz | 3200MT/s | 280W |
| AMD Ryzen 3700X [\[4\]](#references) | @2200MHz | 3200MT/s | 65W |

## Results

![](/benchmarks/sim-size-scaling.png)

| Processor | $a$ | $b$ | $c$ |
| --- | --- | --- | --- |
| 12700H | $0.04562$ | $5.05\times 10^{-5}$ | $1.294\times 10^{-25}$ |
| 3960X | $5.072\times 10^{-16}$ | $5.267\times 10^{-5}$ | $4.346\times 10^{-14}$ |
| 3700X | $8.772\times 10^{-21}$ | $3.306\times 10^{-5}$ | $2.948\times 10^{-10}$ |

```bash
=============================================
| Fitting summary for 12700H @2GHz with polynomial of order 3
|--------------------------------------------
| Coefficients:  p2=1.294e-25 p1=5.05e-05 p0=0.04562
| Effects at n_agents=327680:
| Contribution at n_agents=        80:  c2=1.0000e+00 c1=1.0040e+00 c0=1.0467e+00
| Relative                              r2=     32.8% r1=     32.9% r0=     34.3%
| Contribution at n_agents=       320:  c2=1.0000e+00 c1=1.0163e+00 c0=1.0467e+00
| Relative                              r2=     32.6% r1=     33.2% r0=     34.2%
| Contribution at n_agents=      1280:  c2=1.0000e+00 c1=1.0668e+00 c0=1.0467e+00
| Relative                              r2=     32.1% r1=     34.3% r0=     33.6%
| Contribution at n_agents=      5120:  c2=1.0000e+00 c1=1.2950e+00 c0=1.0467e+00
| Relative                              r2=     29.9% r1=     38.8% r0=     31.3%
| Contribution at n_agents=     20480:  c2=1.0000e+00 c1=2.8128e+00 c0=1.0467e+00
| Relative                              r2=     20.6% r1=     57.9% r0=     21.5%
| Contribution at n_agents=     81920:  c2=1.0000e+00 c1=6.2596e+01 c0=1.0467e+00
| Relative                              r2=      1.5% r1=     96.8% r0=      1.6%
| Contribution at n_agents=    327680:  c2=1.0000e+00 c1=1.5353e+07 c0=1.0467e+00
| Relative                              r2=      0.0% r1=    100.0% r0=      0.0%
| Contribution at n_agents=   1310720:  c2=1.0000e+00 c1=5.5556e+28 c0=1.0467e+00
| Relative                              r2=      0.0% r1=    100.0% r0=      0.0%
=============================================
| Fitting summary for 3960X @2GHz with polynomial of order 3
|--------------------------------------------
| Coefficients:  p2=4.346e-14 p1=5.276e-05 p0=5.072e-16
| Effects at n_agents=5242880:
| Contribution at n_agents=        80:  c2=1.0000e+00 c1=1.0042e+00 c0=1.0000e+00
| Relative                              r2=     33.3% r1=     33.4% r0=     33.3%
| Contribution at n_agents=       320:  c2=1.0000e+00 c1=1.0170e+00 c0=1.0000e+00
| Relative                              r2=     33.1% r1=     33.7% r0=     33.1%
| Contribution at n_agents=      1280:  c2=1.0000e+00 c1=1.0699e+00 c0=1.0000e+00
| Relative                              r2=     32.6% r1=     34.9% r0=     32.6%
| Contribution at n_agents=      5120:  c2=1.0000e+00 c1=1.3102e+00 c0=1.0000e+00
| Relative                              r2=     30.2% r1=     39.6% r0=     30.2%
| Contribution at n_agents=     20480:  c2=1.0000e+00 c1=2.9464e+00 c0=1.0000e+00
| Relative                              r2=     20.2% r1=     59.6% r0=     20.2%
| Contribution at n_agents=     81920:  c2=1.0003e+00 c1=7.5365e+01 c0=1.0000e+00
| Relative                              r2=      1.3% r1=     97.4% r0=      1.3%
| Contribution at n_agents=    327680:  c2=1.0047e+00 c1=3.2260e+07 c0=1.0000e+00
| Relative                              r2=      0.0% r1=    100.0% r0=      0.0%
| Contribution at n_agents=   1310720:  c2=1.0775e+00 c1=1.0831e+30 c0=1.0000e+00
| Relative                              r2=      0.0% r1=    100.0% r0=      0.0%
| Contribution at n_agents=   5242880:  c2=3.3021e+00 c1=1.3763e+120 c0=1.0000e+00
| Relative                              r2=      0.0% r1=    100.0% r0=      0.0%
| Contribution at n_agents=  20971520:  c2=1.9982e+08 c1=inf c0=1.0000e+00
| Relative                              r2=      0.0% r1=      nan% r0=      0.0%
=============================================
| Fitting summary for 3700X @2.2GHz with polynomial of order 3
|--------------------------------------------
| Coefficients:  p2=2.948e-10 p1=3.306e-05 p0=8.772e-21
| Effects at n_agents=5120:
| Contribution at n_agents=        80:  c2=1.0000e+00 c1=1.0026e+00 c0=1.0000e+00
| Relative                              r2=     33.3% r1=     33.4% r0=     33.3%
| Contribution at n_agents=       320:  c2=1.0000e+00 c1=1.0106e+00 c0=1.0000e+00
| Relative                              r2=     33.2% r1=     33.6% r0=     33.2%
| Contribution at n_agents=      1280:  c2=1.0005e+00 c1=1.0432e+00 c0=1.0000e+00
| Relative                              r2=     32.9% r1=     34.3% r0=     32.9%
| Contribution at n_agents=      5120:  c2=1.0078e+00 c1=1.1844e+00 c0=1.0000e+00
| Relative                              r2=     31.6% r1=     37.1% r0=     31.3%
| Contribution at n_agents=     20480:  c2=1.1316e+00 c1=1.9681e+00 c0=1.0000e+00
| Relative                              r2=     27.6% r1=     48.0% r0=     24.4%
```
<!-- 
| Datapoint | 0th order | 1st order | 2nd order |
| --- | --- | --- | --- |
| $p_1$ |
| $p_2$ |
| $p_3$ |
| $p_4$ |
| $p_4$ |
| $p_5$ |
| $p_6$ |
| $p_7$ |
| $p_8$ |
| $p_9$ |
-->

## Discussion
Compared to other recent developments [\[5\]](#references)

## References

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
C. Borau, R. Chisholm, P. Richmond, and D. Walker,
“An agent-based model for cell microenvironment simulation using FLAMEGPU2,”
Computers in Biology and Medicine, vol. 179. Elsevier BV, p. 108831,
Sep. 2024. doi: 10.1016/j.compbiomed.2024.108831.
