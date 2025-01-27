---
title: "cr_trichome"
date: 2024-08-01
math: true
draft: true
---

## Modeling a Trichome Turing Pattern on the leaf of _Arabidopsis Thaliana_

Trichomes are hairs consisting of a single cell which can be seen developing on the surface of
leaves of _Arabidopsis Thaliana_.
Their specialization from regular epithelial cells is determined by a pattern which can be
described by coupling the intracellular reactions of multiple cells to each other.
We assume that cells are immobile but exchange the 'trichome-promoting factor TRANSPARENT TESTA
GLABRA1' (TTGL) [@Bouyer2008] via their connecting cell wall.

We descibe the intracellular gene reulatory network as an Ordinary
Differntial Equation (ODE) via the `Intracellular` simulation aspect and couple cells to each other
with the `ReactionsContact` aspect.
We restrict the reactions via contact to only neighbouring cells exchange TTGL which is particularly
simple to determine for a static tissue.
The combined reactions represent a diffusion-driven Turing instability [@Turing1952] which when
given randomized initial values generates peaks that lead to the observed differentiation of the
trichome hairs.

## Mathematical Description

### Mechanics & Interaction
### Reactions

## Results

### Initial Snapshot

![](/showcase/cr_trichome/cr_trichome_start.png)

### Final Snapshot

![](/showcase/cr_trichome/cr_trichome_end.png)

## Code
