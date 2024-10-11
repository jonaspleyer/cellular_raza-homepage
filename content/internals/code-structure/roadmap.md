---
title: 🎏 Roadmap
type: docs
prev: docs/coding-guidelines
next: docs/
weight: 110
---

The following points outline which features will be worked on in the future.
Even if these features are listed, they may be postponed due to complications or waiting for other features to be figured out before tackling them.
For feature requests, please use [github's issue tracker](https://www.github.com/jonaspleyer/cellular_raza/issues).

## The way to version 0.1
### CellAgent (concepts + backend)
- [x] mechanics via force interactions
- [x] proliferation
- [x] death
    - [x] immediate death
    - [x] phased death
    - [x] make it stochastic
- [x] Custom (individual-only) rules
- [x] General contact functions
    - [x] Contact reactions

### Domain (concepts + backend)
- [ ] Environment Fluid Dynamics
    - [x] PDE Diffusion
    - [ ] Lattice Boltzmann (optional)
    - [ ] Particles (optional)
- [x] Better concepts for domain decomposition
    - [x] Test currently proposed new design
    - [x] Efficiently implement this new concept and benchmark
- [x] Evaluate usage of associated types for some concepts
    - [x] `CellularReactions` concept
    - [x] `Domain` concept
- [ ] Parallelize decomposition of standard CartesianCuboid Domain

### Overall Design
- [x] Parallelization of default backend
- [x] Deterministic results (in default backend, even yield same binary output when changing number of threads)
- [x] Stabilize the new `chili` backend

## Planned for the Future
- [ ] Make it multi-scale: varying time-steps for portions of simulation
    - [ ] Find user Interface for time input
      Time-Scales per concept or per concept-group
- [ ] Complete Deserialization of Simulation
- [ ] Export Formats other then 1:1 storage through (de)serialization (such as vtk files for paraview)
- [ ] Improve Python bindings for some predefined models (using [pyo3](https://github.com/PyO3))
- [ ] Proper error handling with strategies

## Possible Directions
- [ ] Purely GPU powered Backend (probably restricted generics)
- [ ] Custom (adaptive) time steppers
- [ ] Larger-than-memory simulations by using `sled`
- [ ] Julia Bindings
