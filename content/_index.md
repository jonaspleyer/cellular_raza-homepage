---
toc: false
---

{{< hextra/hero-headline >}}
<img class="hx-block dark:hx-hidden" src="/logos/cellular_raza.svg" alt="cellular_raza">
<img class="hx-hidden dark:hx-block" src="/logos/cellular_raza_dark_mode.svg" alt="cellular_raza">
{{< /hextra/hero-headline >}}

{{< hextra/hero-subtitle >}}
Cellular Agent-based Modeling from a Clean Slate
{{< /hextra/hero-subtitle >}}

`cellular_raza` is a cellular
[agent-based modeling](https://en.wikipedia.org/wiki/Agent-based_model) framework
which allows researchers to construct models from a clean slate.
In contrast to other agent-based modelling toolkits, it is free of assumptions about the underlying
cellular representation.
This enables researchers to build up complex models while retaining full control over every
parameter and behaviour introduced.

## Selected [Showcases](/showcase)

{{< cards >}}
    {{<
        card link="/showcase/bacterial-rods"
        title="Soft Bacterial Rods"
        image="/showcase/bacterial-rods/0000007200.png"
        subtitle="A mechanical model of elongated bacteria such as _E.Coli_ growing inside a narrow box."
    >}}
    {{<
        card link="/showcase/semi-vertex-model"
        title="Semi-Vertex Model"
        image="/showcase/semi-vertex-model/snapshot-00000000000000020000.png"
        subtitle="A vertex-based mechanical model which allows for gaps between cells."
    >}}
{{< /cards >}}

## Selected [Benchmarks](/benchmarks)
<!-- TODO this ist just a copy-and-pase and should possibly be automated-->

{{< cards >}}
    {{< card
        link="/benchmarks/2024-07-testing-contact-reactions"
        title="Accuracy Testing of Contact Reactions"
        subtitle="We compare the solvers of `cellular_raza` with analytical results with estimates for the local and global truncation error."
        image="/benchmarks/contact_reactions/contact_reactions-config0.png"
    >}}
    {{< card
        link="/benchmarks/2024-07-thread-scaling"
        title="Multithreading Performance of the Cell Sorting Example (Amdahl's Law)"
        subtitle="We analyze scaling with multiple threads using the `chili` backend and the `cell-sorting` simulation."
        image="/benchmarks/thread_scaling.png"
    >}}
{{< /cards >}}

## Talk at [Scientific Computing in Rust](https://scientificcomputing.rs/)

{{< youtube 3q40ozzQ6gE >}}

## Cite Us

Pleyer, J. and C. Fleck,
(2025)
"cellular_raza: Cellular Agent-based Modeling from a Clean Slate"
Journal of Open Source Software,
June 10th, 2025.
doi: [joss.theoj.org/papers/10.21105/joss.07723](https://joss.theoj.org/papers/10.21105/joss.07723).

```bibtex
@article{Pleyer2025,
    doi = {10.21105/joss.07723},
    url = {https://doi.org/10.21105/joss.07723},
    year = {2025},
    publisher = {The Open Journal},
    volume = {10},
    number = {110},
    pages = {7723},
    author = {Jonas Pleyer and Christian Fleck},
    title = {cellular_raza: Cellular Agent-based Modeling from a Clean Slate},
    journal = {Journal of Open Source Software}
}
```

## Explore
<!-- TODO this ist just a copy-and-pase and should possibly be automated-->

{{< cards >}}
  {{< hextra/feature-card
    link="guides"
    title="Guides"
    icon="pencil"
  >}}
  {{< hextra/feature-card
    title="Showcase"
    link="showcase"
    icon="photograph"
  >}}
  {{< hextra/feature-card
    title="Benchmarks"
    link="benchmarks"
    icon="presentation-chart-bar"
  >}}
  {{< hextra/feature-card
    link="internals"
    title="Internals"
    icon="cog"
  >}}

  {{< hextra/feature-card
    link="docs/cellular_raza"
    title="Docs"
    icon="book-open"
  >}}
  {{< hextra/feature-card
    link="publications"
    title="Publications"
    icon="newspaper"
  >}}

{{< /cards >}}
