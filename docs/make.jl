using Documenter, DayTrade

makedocs(
    sitename = "DayTrade.jl",
    format = Documenter.HTML(
        prettyurls = get(ENV, "CI", nothing) == "true",
        assets = ["assets/style.css"],
    )
)

deploydocs(
    repo = "github.com/CiDAMO/DayTrade.jl.git",
)