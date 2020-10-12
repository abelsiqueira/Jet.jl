@def title = "Jet"
@def tags = ["syntax", "code"]
@def hascode = true
@def lang = "julia"

# Jet.jl

Jet provides a easy way to find Julia snippets.

\tableofcontents <!-- you can use \toc as well -->

## Usage

```julia
julia> using Jet
julia> jet_repl()
julia> # press }
jet>
```

or `jet(str)` or `jet"str"`.

## Actions

### `jet> pkg:something`

Returns all snippets associated with package `something`.

```
jet> pkg:DataFrames
DataFrames

Tools for working with tabular data.

- Create a new DataFrame by passing the column headers and contents
  `df = DataFrame(A = 1:3, B = [:odd, :even, :odd])`
```

Instead of `pkg`, `package` can also be used.

### `jet> cmd:something`

```
jet> cmd:chol
- Solve a linear system `Ax = b` using the Cholesky factorization
  `F = cholesky(A)
  F \ b`
```

Instead of `cmd`, `command` or `snippet` can also be used. The argument can also be ignored.

### `jet> ?`

Same as `pkg:Jet`.

```
jet> cmd:?
Jet

A package for fast help and snippets.

- Enter `jet>` mode.
  `}`

- Search for commands and packages related to the `keyword`.
  `jet"keyword"`
```

## Contributing

The main need of the package right now is to create a useful database. For that, we have created a couple of commands:

### `new_pkg(pkg, description, tags)`

Create a new entry for `pkg` using the `description` and some `tags`.

### `new_snippet([pkg=""], cmd, description, tags)`

Create a new entry (that can be associated to a `pkg`) for a snippet `cmd`.

### Short guide

- Fork this repo
- Clone your repo, create a branch for your contribution(s)
- Go inside, run `julia --project`
- Instantiate the project: `]` becomes `pkg>`, then `pkg> instantiate`
- `using Jet`
- Use `new_pkg` or `new_snippet`
- Commit with a message like "New package: ..." or "New snippet for how to ..."
- Push to your repo, and create a PR to our `main` branch

You can watch a asciinema recording below (But I forgot to commit):

[![asciicast](https://asciinema.org/a/362685.svg)](https://asciinema.org/a/362685)

Note: We use `rebase` and `squash` merges, so `fetch` this repo from time to time and update your `main` branch related to this one. Always branch from `main`.