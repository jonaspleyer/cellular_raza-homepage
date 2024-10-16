---
title: ⚙ Controller
weight: 30
---

An external controller is able to remove and modify cells at will.
This special simulation [aspect](/internals/concepts) is contrary to the philosophy behind local
interactions but resembles an external observer such as an experimentalist.
This aspect can also be used to prematurely abort simulations when a given criterion is reached.
A controller is however not all-knowing and restriced to modifications on the cellular level.
It can not change the internal behaviour of the extracellular domain.

<!-- TODO finish desribing the controller in more detail -->

{{<callout type="warning">}}
The [Controller](/docs/cellular_raza_concepts/trait.Controller.html) trait is currently not
available for the [chili](/internals/backends/chili) backend.
We hope to be adding this feature in the future.
{{< /callout >}}
