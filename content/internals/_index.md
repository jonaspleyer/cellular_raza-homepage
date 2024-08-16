---
linkTitle: "Internals"
cascade:
    type: docs
prev: /
next: internals/folder/
---

`cellular_raza` acts on abstract theoretical simulation [aspects](/internals/concepts) which can be
integrated numerically by [backends](/internals/backends).

## Aspects & Concepts

Learn about the theoretical formulation of simulation [aspects](/internals/concepts) for
[cellular agents](/internals/concepts/cell) or the simulatin [domain](/internals/concepts/domain).
We provide a high-level overview with some examples to illustrate our points.

## Backends

[Backends](/internals/backends) are used to numerically integrate specified simulation
[aspects](/internals/concepts).
`cellular_raza` was designed with the assumption that multiple backends can be implemented for
various usecases.
We describe the most important technical aspects as well as assumptions and restrictions of the
current default [`chili`](/internals/backends/chili) backend.

## Code Structure

This gives an overview over the organizational structure behind `cellular_raza`.
If you want to contribute to the project, this is a good place to start.
Please consider reading the [Coding Guidelines](/internals/code-structure/coding-guidelines) and
have a look at the list of [open problems](/internals/code-structure/open-problems).
