---
title: ⎇ Releases
type: docs
weight: 100
---

{{< callout type="warn" >}}
To this date, version numbers do not follow the [semver](https://semver.org/) specification.
We are working towards this goal and will report our progress.
{{< /callout >}}

### cellular_raza 0.1.4
[_9th  November 2024_](git_diff-0.1.4-incremental.diff)

- Add testing for `windows-latest`, `macos-12` and `macos-13`
- Publish [`uniquevec`](https://crates.io/crates/uniquevec) crate from code developed in `storage`
  module of `cellular_raza_core` and use as dependency.
- Extend [`UpdateMechanics`](/docs/cellular_raza_core/backend/chili/trait.UpdateMechanics.html) and
  [`UpdateReactions`](/docs/cellular_raza_core/backend/chili/trait.UpdateReactions.html) traits
  to not rely on [`num::Zero`](https://docs.rs/num/latest/num/trait.Zero.html) trait
- Extend [`run_simulation`](/docs/cellular_raza_core/backend/chili/macro.run_simulation.html)
  macros and derivatives with new keywords
    - Specify names of [`AuxStorage`](/docs/cellular_raza_core/backend/chili/) and
      [`Communicator`](/docs/cellular_raza_core/backend/chili)
    - Specify orders of solvers (for [Mechanics](/internals/concepts/cell/mechanics) and
      [Reactions](/internals/concepts/cell/reactions)
    - Set zero-values for [Force](/internals/concepts/cell/mechanics) and
      [Intracellular](/internals/concepts/cell/reactions) (useful for dynamically-sized structs
      which do not support the [num::Zero](https://docs.rs/num/latest/num/trait.Zero.html) trait.

### cellular_raza 0.1.3
[_26th October 2024_](git_diff-0.1.3-incremental.diff)

- Bugfix for assigning correct
  [`CellIdentifier`](/docs/cellular_raza_core/backend/chili/struct.CellIdentifier.html) for parent
  cell
- Version `0.1.2` was yanked due to incorrect bugfix attempt

### cellular_raza 0.1.1
[_18th October 2024_](git_diff-0.1.1-incremental.diff)

- Adapt some tests and plotting of them
- cleanup module structure for time and some tests
- More detailed descriptions of [concepts](/internals/concepts)
- New formulation of [MorsePotential](/docs/cellular_raza_building_blocks/struct.MorsePotential.html)
- Corrected bugs in the [Langevin](/docs/cellular_raza_building_blocks/struct.Langevin.html)
  mechanics model
- Abstract [Bacterial Rods](/showcase/bacterial-rods) example into building blocks
- Start new subproject [cr_mech_coli](https://github.com/jonaspleyer/cr_mech_coli) to build
  mechanistic, mechanical _E.Coli_ model
- Changed how identifiers will be updated after division:
  both cells will now receive new identifiers, in the future we want to extend this to arbitrary
  numbers in order to support multiple fission
- Removed unused `cellular_raza-building_blocks::prelude`

### cellular_raza 0.1.0
[_28th August 2024 🎉 2 Year Anniversary 🎉_](git_diff-0.1.0-incremental.diff)
- Changed calculation of random contribution in `Mechanics` trait
    - Improved stochastic motion testing for Brownian and Langevin dynamics
- Derive macros now support tuple structs
- Implemented extracellular [reactions](/internals/concepts/domain/reactions)
    - First example: bacterial branching
- Add rayon as parallelization scheme
- Improved error handling
    - properly wind down simulation after encountering error
    - First experimentation with error handlers
- Rename some trait functions and variables from `neighbour` to `neighbor`

## Pre-0.1 Releases
### cellular_raza 0.0.13
[_30th July 2024_](git_diff-0.0.13-incremental.diff)
- Advanced testing for contact reactions and solvers
- Added Ron storage option
- Restructured and simplified storage solutions
- Improve (but also change parameters) CLI for benchmarks
- Use new [`circ_buffer`](https://crates.io/crates/circ_buffer) crate in chili backend
- Bugfixes for contact reactions
- Move homepage to separate repository
- New function to create timestepper `from_partial_save_freq`
- Update nalgebra to version "0.33"

### cellular_raza 0.0.12
[_13th July 2024_](git_diff-0.0.12-incremental.diff)
- Implement concepts for contact reactions
- Add option to enable/disable determinism
- Correct some bugs and implement functionality for storage solutions

### cellular_raza 0.0.11
[_18th June 2024_](git_diff-0.0.11-incremental.diff)
- corretly treat interaction functions related to neighbours
  [`is_neighbour`](/docs/cellular_raza_concepts/trait.Interaction.html#method.is_neighbour) and
  [`react_to_neighbours`](/docs/cellular_raza_concepts/trait.Interaction.html#method.react_to_neighbours)
  in the [chili](/internals/backends/chili) backend.
- Modifications to examples

### cellular_raza 0.0.10
[_11th June 2024_](git_diff-0.0.10-incremental.diff)
- Change [Interaction](/internals/concepts/cell/interaction) concept to return two force values for
  own and other cell.
- Fix some bugs in [chili](/internals/backends/chili) backend (mainly related to
  [Cycle](/internals/concepts/cell/cycle) concept)
- migrate some examples from old `cpu_os_threads` to new [chili](/internals/backends/chili) backend
- Change [VertexDerivedInteraction](/docs/cellular_raza_building_blocks/struct.VertexDerivedInteraction.html)
  to use closest point on external polygon

### cellular_raza 0.0.9
[_1st June 2024_](git_diff-0.0.9-incremental.diff)
- Major improvements to the [chili](/internals/backends/chili) backend
    - Stabilize main routines and macros
    - Tested workflow with actual examples
- Stabilize [new domain](/docs/cellular_raza_concepts/domain_new) traits
- Added more examples
- Developed [`approx-derive`](https://crates.io/crates/approx-derive) crate to more easily test
  approximate results for complex datatypes.

{{< callout type="info" >}}
From now on releases will become more frequent and for smaller feature additions such that version
0.1.0 can be reached sooner.
{{< /callout >}}

### cellular_raza 0.0.8
[_16th February 2024_](git_diff-0.0.8-incremental.diff)
- Added documentation where needed
- Fix public interface for cpu_os_threads backend
- Compared to 0.0.7 this new version will almost only fix Documentation and dependencies for the nightly compiler

### cellular_raza 0.0.7
[_16th February 2024_](git_diff-0.0.7-incremental.diff)
- More experimenting with trait for fluid dynamics
- Improved documentation and website
- Only minor advancements in backend development

### cellular_raza 0.0.6
[_2nd February 2024_](git_diff-0.0.6-incremental.diff)
Further development of `chili` backend:
- Extend documentation and development of the chili backend
- Template simulation contains raw experimentation with this new backend
- Mechanics and Interaction trait working
- Concise API for running simulations still missing
- Proc-macro crate has been expanded with many useful helper macros
- Next version might contain a first working iteration of the chili backend

### cellular_raza 0.0.5
[_12th December 2023_](git_diff-0.0.5-incremental.diff)
- Include some pyo3 fixes (prevented from compiling in 0.0.4)

### cellular_raza 0.0.4
[_6th December 2023_](git_diff-0.0.4-incremental.diff)
- Add readme files
- Minor bugfix for pyo3 binding generation in building blocks

### cellular_raza 0.0.3
[_6th March 2023_](git_diff-0.0.3-incremental.diff)

### cellular_raza 0.0.2
[_22nd February 2023_](git_diff-0.0.2-incremental.diff)

### cellular_raza 0.0.1
[_13th December 2023_](git_diff-0.0.1-incremental.diff)

### initial commit
_27th August 2022_
