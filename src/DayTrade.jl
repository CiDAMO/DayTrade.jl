module DayTrade

using LinearAlgebra

export example_least_squares

function example_least_squares(X, y)
  X \ y
end

end # module
