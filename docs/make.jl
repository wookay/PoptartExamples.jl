using Documenter

makedocs(
    build = joinpath(@__DIR__, "local" in ARGS ? "build_local" : "build"),
    modules = Module[],
    clean = false,
    format = Documenter.HTML(),
    sitename = "PoptartExamples.jl 🏂",
    authors = "WooKyoung Noh",
    pages = Any[
        "Home" => "index.md",
    ],
)
