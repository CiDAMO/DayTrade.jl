using DayTrade, LinearAlgebra, Test

@testset "example" begin
  X = rand(10, 5)
  y = X * ones(5) + randn(10) * 0.3
  β = example_least_squares(X, y)
  @test norm(X' * (X * β - y)) < 1e-6
end