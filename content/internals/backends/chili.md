---
title: 🌶️ chili
weight: 10
---

> A modular, reusable, general purpose backend

The `chili` backend acts in two phases.
In the first phase, source code is being generated by 
[macros](https://doc.rust-lang.org/reference/macros-by-example.html) and
[generics](https://doc.rust-lang.org/reference/items/generics.html).
Afterwards, the generated code is compiled and run.
To leverage the strong type-system and compiler optimizations of the Rust compiler `rustc`,
`cellular_raza` makes extensive use of these methods.

# Code generation
`cellular_raza` provides generic [concepts](/internals/concepts) which need to be numerically
integrated.

The `chili` backend makes extensive use of macros in order to build a fully working simulation.
Three macros stand out in particular:
[`build_aux_storage`](/docs/cellular_raza_core/backend/chili/macro.build_aux_storage.html)
[`build_communicator`](/docs/cellular_raza_core/backend/chili/macro.build_communicator.html) and
[`run_main`](/docs/cellular_raza_core/backend/chili/macro.run_main.html).
They can also be used in tandem via the 
[`run_simulation`](/docs/cellular_raza_core/backend/chili/macro.run_simulation.html) macro.

## Aux Storage

To store additional information for cell-agents such as position, velocity increments used by the
solver or information about next update steps of the [cycle](/internals/concepts/cell/cycle) trait,
we need an additional struct that holds this information.
The [chili](/internals/backend/chili) backend provides the
[`build_aux_storage`](/docs/cellular_raza_core/backend/chili/macro.build_aux_storage.html) macro
which inserts code that defines said struct depending on which
[concepts](/internals/concepts/cell/) the user chose.

## Communicator

The [chili]((/internals/backend/chili) backend uses parallelization across multiple threads.
Since `cellular_raza` makes use of [domain decomposition](/internals/concepts/domain) methods,
we must be able to communicate and synchronize between threads.
The [`build_communicator`](/docs/cellular_raza_core/backend/chili/macro.build_communicator.html)
macro inserts code which defines a new struct that fulfills this purpose.

## Main function

To numerically solve the specified system, [chili](/internals/backend/chili) provides the
[`run_main`](/docs/cellular_raza_core/backend/chili/macro.run_main.html) macro.
It decomposes the domain with the cells and distributes the workload across multiple threads.
The main purpose of this macro is to insert only update functions which correspond to the selected
simulation aspects.
It also handles storage of simulation results.