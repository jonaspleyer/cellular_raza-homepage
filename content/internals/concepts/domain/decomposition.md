---
title: 🔪 Decomposition
weight: 10
---

## Partitioning

The idea of partitioning the domain is encapsulated within the
[`Domain`](/docs/cellular_raza_concepts/trait.domain.html) trait which is only responsible for the
partitioning process into multiple `SubDomains`.
Within these smaller regions of space, all update steps are handled locally.
This also means that every [aspect](..) will be implemented on the `SubDomain` level rather than on
the `Domain` level.
The [`Domain`](/docs/cellular_raza_concepts/trait.domain.html) trait exposes the `decompose` method
which is the single function that is responsible for the decomposition process.

```rust
fn decompose(
    self,
    n_subdomains: core::num::NonZeroUsize,
    cells: Ci,
) -> Result<DecomposedDomain<Self::SubDomainIndex, S, C>, DecomposeError>;
```

It takes a current instance of a domain and the number of subdomains which should be generated.
Note that this method is not required to actually generate the exact amount but can opt to provide a
number which is lower than that of `n_subdomains`.
This may be the case if a particular domain can not be divided arbitrarily often.

The resulting type is a
[`DecomposedDomain`](/docs/cellular_raza_concepts/struct.DecomposedDomain.html) which serves as a
simple container holding all information about the created subdomains and their neighbor status.
However this type is not used directly but only serves as an intermediate construct.
The [chili](../../../backends/chili) backend (for example) will immediately use the entries to spawn
individual threads for each entry of the `index_subdomain_cells` field of the `DecomposedDomain`.

### SubDomains

The [`SubDomain`](/docs/cellular_raza_concepts/trait.SubDomain.html) trait is the basic interface
for constructing a well-defined net of subdomains.
We assume that we can split our domain into small chunks which are represented by the associated
type `SubDomain::VoxelIndex`.
Each subdomain consists of multiple such indices and contains knowledge about neighboring indices
even though they might live in different subdomains.
Thus it is not trivial to build a domain which satisfies this condition.
The [chili](../../../backends/chili) backend wraps the `SubDomain` type and also stores additional
information needed for storing intermediate information and numerical solving of the system.

## Implementation

It is not recommended to start implementing a completely new domain from the ground up.
Instead, users are encouraged to rely on existing functionality first as explained in the
[building-blocks](/guides/building-blocks) guide.
This guide also explains how to adapt existing domains to new mechanical representations of cells.
To view an example of an implementation, we refer to the
[`CartesianCuboid`](/docs/cellular_raza_building_blocks/struct.CartesianCuboid.html) struct.
