---
title: Guides
cascade:
  type: docs
---

All user Guides assume a basic knowledge of the Rust programming language.
To get started with writing Rust please follow the guidance on the [official website](https://www.rust-lang.org).
For an introduction to cellular agent-based modeling, please refer to [wikipedia](https://en.wikipedia.org/wiki/Cell-based_models) and our [review](https://doi.org/10.3389/fphy.2022.968409).
Although beneficial, we do not expect the reader of these guides to be familiar with any computational methods.

## Overview

The guides in this section are designed to provide insights into different
[cellular aspects](/internals/concepts/cell), [domain aspects](/internals/concepts/domain) and to
teach how to construct simulations bottom-up.
They are fully working examples of simulations executed with `cellular_raza`.

However, we also provide [templates](/guides/templates) which can be used as starting points for the
development of new simulations.

| Guide | Description |
| --- | --- |
| [Introduction](introduction) | General assumptions and setting of `cellular_raza` |
| [Getting Started](getting-started) | Good first starting point. Learn the fundamentals of `cellular_raza` |
| [Building Blocks](building-blocks) | Use predefined building blocks to combine them into a fully working simulation. |
| [Python Bindings](python-bindings) | Learn how to develop python packages with `cellular_raza` as a numerical backend. |

## Templates

Templates provide an initial starting point to construct new simulations.
They can be easily forked directly using github and extended for your own usecase.

We provide two slightly different variants to build up a reliable simulation infrastructure.
The [cellular_raza-template](https://github.com/jonaspleyer/cellular_raza-template) is purely
written in Rust while
[cellular_raza-template-pyo3](https://github.com/jonaspleyer/cellular_raza-template-pyo3) provides
Python bindings in addition (see also [python-bindings](python-bindings)).
Both templates automatically generate a working documentation which is hosted with the
github-integrated services.

While these templates can serve as a starting point but are not representative of the variability
which `cellular_raza` offers (see [showcase](/showcase)).
