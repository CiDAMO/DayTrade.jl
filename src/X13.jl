include("ema.jl")

function X13(candles)
  if size(candles, 1) < 34
  elseif size(candles, 1) == 34
    arr = []
    for i in 34:-1:1
      push!(arr, candles[i, 6])
    end

    ME13  = ema(arr[1:13], 13)
    ME34  = ema(arr, 34)
    OPEN  = candles[33, 3]
    CLOSE = candles[33, 6]

    if ME13 ≥ ME34
      if OPEN ≤ ME13 && CLOSE ≥ ME13
        return Dates.DateTime(parse(Int, split(candles[33,1], ".")[1]), parse(Int, split(candles[33,1], ".")[2]), parse(Int, split(candles[33,1], ".")[3]), Dates.hour(candles[33,2]), (Dates.minute(candles[33,2]) + 2) % 60), "Compra"
      end
    else
      if OPEN > ME13 && CLOSE < ME13
        return Dates.DateTime(parse(Int, split(candles[33,1], ".")[1]), parse(Int, split(candles[33,1], ".")[2]), parse(Int, split(candles[33,1], ".")[3]), Dates.hour(candles[33,2]), (Dates.minute(candles[33,2]) + 2) % 60), "Venda"
      end
    end
  else
    entradas = []
    for i in 0:size(candles, 1)-34
      sub = X13(candles[1+i:34+i, :])
      if sub != nothing
        push!(entradas, sub)
      end
    end
    return entradas
  end
end
