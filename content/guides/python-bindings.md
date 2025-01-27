---
title: Python Bindings
weight: 40
draft: true
---

`cellular_raza` was designed such that it can be used as a numerical backend for `python`
applications.
We use the [`pyo3`](https://pyo3.rs/) to automatically generate these bindings and install the
resulting package in a local virtual environment.

{{< callout type="warning" >}}
All `pyo3` versions are required to match.
{{< /callout >}}

- Explain template https://github.com/jonaspleyer/cellular_raza-template-pyo3
- Other examples
    - cr_trichome https://github.com/jonaspleyer/cr_trichome
    - cr_mech_coli https://github.com/jonaspleyer/cr_mech_coli
- Refer to [Getting Started](/guides/getting-started) guide
- `pyo3`
- Generics
- Recommended structure
- Example `cellular_raza-template-pyo3`
