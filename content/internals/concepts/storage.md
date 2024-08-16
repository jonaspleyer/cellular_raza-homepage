---
title: 📦 Storage
weight: 40
---

`cellular_raza` assumes that every cell-agent and domain component can be serialed via the
[serde](https://serde.rs/) crate.
This allows us to create full snapshots of an entire simulation which can in principle be used to
load previously executed simulations and continue them.
Said feature is currently not available but part of our [roadmap](/internals/roadmap).
Furthermore, users retain full transparency of every cellular and domain parameter.

# Options
`cellular_raza` provides multiple storage formats:

| Format | Description |
|:---:| --- |
| [json](https://docs.rs/serde_json/latest/serde_json/) | Stores results in files of the popular json format. A good general-purpose choice for most applications. |
| [xml](https://docs.rs/serde-xml-rs/latest/serde_xml_rs/) | DEPRECATED Stores results in the xml format. |
| [sled](https://docs.rs/sled/latest/sled/) | An emdedded database similar to a `BTreeMap`. |
| [sled (temp)](https://docs.rs/sled/latest/sled/) | Identical to `sled` but removes results after commencing. Can be used for temporary results such as benchmarks and tests. |
| [Ron](https://docs.rs/ron/latest/ron/) | Streos in files with Rust-specific object notation. Arguably most reliable choice but less support in other environments. |
| [Memory](https://doc.rust-lang.org/std/collections/struct.BTreeMap.html) | Purely memory-based storage solution. Mainly used for small simulations, benchmarks and tests. |

Of the listed options, all save simulation results to the disk while the "sled (temp)" option
erases any created files after it has commenced.

