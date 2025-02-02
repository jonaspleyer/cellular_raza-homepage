---
title: Getting Started
weight: 10
math: true
---

In this introduction we will describe the basic way of using `cellular_raza`.
We assume that the reader is already somewhat familiar with the Rust programming language and has
installed the [cargo](https://doc.rust-lang.org/cargo/) package manager.
You can find instructions for its installation at
[www.rust-lang.org/tools/install](https://www.rust-lang.org/tools/install).

## Simulation Code

To create a new project from scratch, initialize an empty project with cargo and change to this directory.
```bash
cargo init my-new-project
cd my-new-project
```

Afterwards add `cellular_raza` as a dependency.
```bash
cargo add cellular_raza serde rand rand_chacha num
```

Afterwards, we have the following structure of files.

{{< filetree/container >}}
    {{< filetree/folder name="src" >}}
        {{< filetree/file name="main.rs" >}}
    {{< /filetree/folder >}}
    {{< filetree/file name="Cargo.toml" >}}
{{< /filetree/container >}}

For now, we only implement physical interactions via the
[Mechanics](/internals/concepts/cell/mechanics) and
[interaction](/internals/concepts/cell/interaction) simulation aspects.
We can quickly build simulations by combining already existing [building_blocks](building-blocks)
with the [CellAgent](/docs/cellular_raza-concepts/derive.CellAgent.html) derive macro.

### Imports

We begin with some import statements which will be used later on.

{{< codeFromFile
    file="cellular_raza/cellular_raza-examples/getting-started/src/main.rs"
    filename="cellular_raza-examples/getting-started/src/main.rs"
    start="1"
    end="5"
>}}

### Cellular Agent

In the next step, we define the cellular agent.
This simplistic example only considers two [cellular aspects](/internals/concepts):
[`Mechanics`](/internals/concepts) and [`Interaction`](/internals/concepts).
We describe the movement of cells via Langevin dynamics with the
[`Langevin2D`](/docs/cellular_raza_building_blocks/struct.Langevin2D.html) struct which
assumes that cells can be represented as point-like particles in $d=2$ dimensions.
Furthermore, every cell moves stochastically through space.
They interact via forces given by the
[`MorsePotential`](/docs/cellular_raza_building_blocks/struct.MorsePotential.html) struct.

{{< codeFromFile
    file="cellular_raza/cellular_raza-examples/getting-started/src/main.rs"
    filename="cellular_raza-examples/getting-started/src/main.rs"
    start="7"
    end="13"
>}}

We define a struct which stores all necessary parameters of the system.
This gives us a unified way to change parameters of the simulation.

{{< callout type="info" >}}
Note that this step is not strictly required but we highly recommend it.
{{< /callout >}}

{{< codeFromFile
    file="cellular_raza/cellular_raza-examples/getting-started/src/main.rs"
    filename="cellular_raza-examples/getting-started/src/main.rs"
    start="15"
    end="52"
>}}

In the next step we initialize all components of the simulation.
We start by creating the cellular agents by using the values from the `Parameters` struct.
Only the position is overwritten such that cells are placed inside the domain randomly.
We chose the [`CartesianCuboid`](/docs/cellular_raza_building_blocks/struct.CartesianCuboid) struct
as our domain and initialize it from the domain size and the interaction cutoff of the
[`MorsePotential`](/docs/cellular_raza_building_blocks/struct.MorsePotential).

At last, we define start, end and time-increment together with the folder to store results.
This folder will be automatically created.
All properties are stored in the
[`Settings`](/docs/cellular_raza_core/backend/chili/struct.Settings) struct.

{{< codeFromFile
    file="cellular_raza/cellular_raza-examples/getting-started/src/main.rs"
    filename="cellular_raza-examples/getting-started/src/main.rs"
    start="54"
    end="93"
>}}

Finally, we can run the simulation.
The [chili](/internals/backends/chili) backend uses the
[`run_simulation`](/docs/cellular_raza_core/backend/chili/macro.run_simulation) macro to set up and
run the specified simulation.
Also, we need to tell our simulation which [aspects](/internals/concepts) to solve for.

{{< codeFromFile
    file="cellular_raza/cellular_raza-examples/getting-started/src/main.rs"
    filename="cellular_raza-examples/getting-started/src/main.rs"
    start="95"
    end="102"
>}}

## Executing the Simulation

Now we can use `cargo` to compile and execute the project in release mode with all possible
optimizations.

A progress bar will show up that indicates the progress and speed of execution.

```
$ cargo run -r
    Finished `release` profile [optimized] target(s) in 0.40s
     Running `my-new-project/target/release/cr_getting_started`
 81%|██████████████████████▊     | 80856/100000 [00:02, 28803.93it/s]

```

During the simulation, results will be written to the `out` folder which contains information about
every individual agent and the simulation domain.
In the next step, we will see how to [visualize](#plotting-results) these results.

{{< filetree/container >}}
    {{< filetree/folder name="out" >}}
        {{< filetree/folder name="2024-09-02-T15-08-12" />}}
        {{< filetree/folder name="2024-09-02-T15-11-03" />}}
        {{< filetree/folder name="..." />}}
    {{< /filetree/folder >}}
{{< /filetree/container >}}

## Visualization
### Reading Results

To visualize the results spatially, we write a small python script.
We utilize the [`numpy`](https://numpy.org/), [`matplotlib`](https://matplotlib.org/) and
[`tqdm`](https://github.com/tqdm/tqdm) packages.
Every other functionality is contained in the standard library of python.

We again start by importing the required functionalities.
Their uses will become clear in just a moment.

{{< codeFromFile
    file="cellular_raza/cellular_raza-examples/getting-started/src/plotting.py"
    filename="cellular_raza-examples/getting-started/src/plotting.py"
    lang="python"
    start="1"
    end="9"
>}}

The results of the simulation have been saved in the popular `json` format.
Cells and subdomains are stored in separate folders.

{{< filetree/container >}}
    {{< filetree/folder name="out" >}}
        {{< filetree/folder name="2024-09-02-T15-08-12" >}}
            {{< filetree/folder name="cells/json" />}}
            {{< filetree/folder name="subdomains/json" />}}
        {{< /filetree/folder >}}
        {{< filetree/folder name="2024-09-02-T15-11-03" />}}
        {{< filetree/folder name="..." />}}
    {{< /filetree/folder >}}
{{< /filetree/container >}}

We define a couple of functions to load and store these results.
Note that the only information related to the subdomains which is used for plotting is the total
domain size which is fixed from the beginning.
We can therefore load it only once and need not to change it again.

{{< codeFromFile
    file="cellular_raza/cellular_raza-examples/getting-started/src/plotting.py"
    filename="cellular_raza-examples/getting-started/src/plotting.py"
    lang="python"
    start="11"
    end="31"
>}}

### Creating Snapshots

It is usefull to define a new class for plotting the results.
The `Plotter` class creates a figure and axis when being initialized.
It can reuse these variables when plotting multiple iterations in succession.
This is being done by the `plot_iteration` method while `save_iteration` also stores the created
figure in the path  where the results are stored in.

{{< codeFromFile
    file="cellular_raza/cellular_raza-examples/getting-started/src/plotting.py"
    filename="cellular_raza-examples/getting-started/src/plotting.py"
    lang="python"
    start="33"
    end="74"
>}}


### Generating Movie (Optional)

We can create a movie from the individual snapshots.
To do this, we utilize `ffmpeg`

{{< details title="Code" closed="true" >}}
{{< codeFromFile
    file="cellular_raza/cellular_raza-examples/getting-started/src/plotting.py"
    filename="cellular_raza-examples/getting-started/src/plotting.py"
    lang="python"
    start="76"
    end="88"
>}}
{{< /details >}}

<div style="width: 100%; padding-top: 1em;">
    <video controls style="margin-left: auto; margin-right: auto;">
        <source src="/guides/getting-started/movie.mp4" type="video/mp4">
    </video>
</div>

### Main

In our main function, we combine all the functionality defined above.


{{< codeFromFile
    file="cellular_raza/cellular_raza-examples/getting-started/src/plotting.py"
    filename="cellular_raza-examples/getting-started/src/plotting.py"
    lang="python"
    start="90"
>}}

After we have generated the snapshots and the movie, our folder structure now contains these
additional files.

{{< filetree/container >}}
    {{< filetree/folder name="out" >}}
        {{< filetree/folder name="2024-09-02-T15-08-12" >}}
            {{< filetree/folder name="cells" />}}
            {{< filetree/folder name="snapshots" />}}
            {{< filetree/folder name="subdomains" />}}
            {{< filetree/file name="movie.mp4" >}}
            {{< /filetree/folder >}}
        {{< filetree/folder name="2024-09-02-T15-11-03" />}}
        {{< filetree/folder name="..." />}}
    {{< /filetree/folder >}}
{{< /filetree/container >}}

