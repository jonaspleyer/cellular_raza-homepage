---
title: ⎇ Releases
type: docs
weight: 100
---

{{< callout type="warn" >}}
To this date, version numbers do not follow the [semver](https://semver.org/) specification.
We are working towards this goal and will report our progress.
{{< /callout >}}

## Pre-1.0 Releases

### cellular_raza 0.4.1
[_11th December 2025_](git_diff-0.4.1-incremental.diff)
- Change order in which boundary conditions are applied by `run_simulation` macro
    - This ensures that cells are within the domain when other update functions are invoked
- Remove codegen for deprecated nvidia devices
- Add configuration options for bacterial branching example

### cellualr_raza 0.4.0
[_29 Sep 2025_](git_diff-0.4.0-incremental.diff)
- Default time stepper can now also store initial state
- Migrate pool model to [separate repository](https://github.com/polinagaindrik/pool_model_paper)
- Update dependencies

### cellular_raza 0.3.2
[_17th September 2025_](git_diff-0.3.2-incremental.diff)

- Allow to set description of progressbar
    - Migrate from `show_progressbar` to simply `progressbar`
- Update dependencies

### cellular_raza 0.3.1
[_10th September 2025_](git_diff-0.3.1-incremental.diff)

- Update dependencies
- Implement constructor to use
  [`VoxelPlainIndex`](/docs/cellular_raza_core/backend/chili/struct.VoxelPlainIndex.html) in Python
  API

## cellular_raza 0.3.0
[_05th August 2025_](git_diff-0.3.0-incremental.diff)

- Unify and extend functionality of
  [`CellIdentifier`](/docs/cellular_raza_concepts/enum.CellIdentifier.html)
- Removed legacy Domains in favor of single generic
  [`CartesianCuboid`](/docs/cellular_raza_building_blocks/struct.CartesianCuboid.html)
- Derive implementations of [`approxim`](https://docs.rs/approxim)
- Improve deserialization speed of
  [`FileBasedStorage`](/docs/cellular_raza_core/storage/trait.FileBasedStorage.html)
- Added more benchmarks
- Some small performance improvements
    - Calculation of forces in subdomain internally
    - Inline more derived functions and helper functions in [`chili`](/internals/backends/chili)
      backend.
- Split `Interaction` and `InteractionInformation` trait.
    - This is mostly backwards-compatible as the derive attribute `#[Interaction]` still derives
      both of these new traits.

### cellular_raza 0.2.4
[_01st May 2025_](git_diff-0.2.4-incremental.diff)

- Fix `pyo3` testing for template submodules
- Cleanup old code
- Add `plotters` feature
- Add implementations for traits of [`approxim`](https://github.com/jonaspleyer/approxim) crate
- Add diffusion domain to [building-blocks](/docs/cellular_raza_building_blocks/)

### cellular_raza 0.2.3
[_13th March 2025_](git_diff-0.2.3-incremental.diff)

- Fix build error in `0.2.2`

### cellular_raza 0.2.2
[_12th March 2025_](git_diff-0.2.2-incremental.diff)

- Bump rust edition to `2024`
- completely reworked [`bacterial-branching`](/showcase/bacterial-branching) example
- update `bincode` dependency to `2.0`

### cellular_raza 0.2.1
[_25th February 2025_](git_diff-0.2.1-incremental.diff)
- Fix documentation build failure introduced in [0.2.0](#cellular_raza-020)

## cellular_raza 0.2.0
[_23rd February 2025_](git_diff-0.2.0-incremental.diff)

- Implemented `__getitem__` for
  [`CellIdentifier`](/docs/cellar_raza_core/backend/chili/struct.CellIdentifier.html) such that it
  can be used as a python tuple.
- Update slogan and CITATION.cff
- Restructured [`prelude`](/docs/cellular_raza/prelude) exports and adapt examples
- Add examples for homepage `cellular_raza-examples/homepage-training`
- First steps: experimental CUDA code for cara backend
- Remove const-generic parameters for
  [`MiePotential`](/docs/cellular_raza_building_blocks/struct.MiePotential.html)
- Started to modularize proc-macros for generating simulation steps to take custom update functions
- Add more `pyo3` methods to building blocks
- New guide on how to create [python bindings](/guides/python-bindings)

### cellular_raza 0.1.6
[_21st November 2024_](git_diff-0.1.6-incremental.diff)

- Streamline documentation of [chili](/internals/backends/chili) backend, especially macros
- Add more tests for deriving [`ReactionsContact`](/docs/cellular_raza_concepts/trait.ReactionsContact.html)
- Bugfigx for [`CellAgent`](/docs/cellular_raza_concepts/derive.CellAgent.html) derive macro
- Restructure keyword arguments of main macros such that correct compatibility with each other is
  guaranteed
- Enable shorthand initialization for keywords of the
  [`run_simulation`](/docs/cellular_raza_core/backend/chili/macro.run_simulation.html) macro.
- Prepare for submission to JOSS journal

### cellular_raza 0.1.5
[_14th November 2024_](git_diff-0.1.5-incremental.diff)

- Correct calculation of curvature contribution in
  [`RodMechanics`](/docs/cellular_raza_building_blocks/struct.RodMechanics.html).
- Extend documentation of [chili](/internals/backends/chili) backend
- Use new building block
  [`RodMechanics`](/docs/cellular_raza_building_blocks/struct.RodMechanics.html) for bacterial rods
  example
- Fixed bug from `0.1.4` where AuxStorage was initialized with `Default` trait instead of
  `num::Zero` or custom constructor.
- Add macro to yield constructor for the generated `AuxStorage` struct.
- Removed deprecated `xml` storage option.
- Update [`RodMechanics`](/docs/cellular_raza_building_blocks/struct.RodMechanics.html) bending
  force calculation

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

## cellular_raza 0.1.0
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
