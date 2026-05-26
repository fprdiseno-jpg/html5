# Import notes

This repository is a mirror of [ruvnet/ruflo](https://github.com/ruvnet/ruflo)
imported into `fprdiseno-jpg/html5` on the `claude/sharp-euler-HnNOV` branch.

## Why the binary files look weird

The import was performed through a sandboxed pipeline that pushes files as
JSON content. Binary files (`.png`, `.jpg`, `.gif`, `.wasm`, etc.) cannot be
sent as raw bytes through that pipeline, so they were **base64-encoded**.

Two naming conventions are used:

- **Small binaries** (< ~700 KB): stored as `<original>.b64` (a single file
  whose body is the base64-encoded original).
- **Large binaries** (≥ ~700 KB): split into chunks named
  `<original>.b64.part-NN-of-MM` (each chunk holds up to ~480 000 base64
  characters; concatenating all parts in order and base64-decoding rebuilds
  the original).

## Restoring the binaries

A helper script is included at the repo root:

```bash
bash restore-binaries.sh           # decode in place, keep the .b64 shards
bash restore-binaries.sh --clean   # decode and delete the .b64 shards
```

After running it, the working tree matches the upstream `ruvnet/ruflo`
repository.

## What's not here

The import excludes the `.git` history of the upstream repository — only the
working-tree contents of the upstream `main` were imported, as a single set
of commits on this branch.

## Upstream

For the canonical, history-complete copy, refer to:
<https://github.com/ruvnet/ruflo>
