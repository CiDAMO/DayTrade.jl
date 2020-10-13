using DataFrames
using CSV
using Dates

include("backtest.jl")

candles = DataFrame(CSV.File(joinpath(@__DIR__, "data_candles.csv")))
ticks = DataFrame(CSV.File(joinpath(@__DIR__, "data_ticks.csv")))
backtest("robo", ticks, candles)