global saldo, pos = 0, [0, 0, 0, 0]

function compra(valor, volume = 1)
  if pos[1] !== 1
    global pos = [1, "Compra", valor, volume]
  else
    if pos[2] == "Venda"
      for i in 1:volume
        if pos[4] == 0
          global pos = [1, "Compra", valor, volume-i+1]
          break
        end
        global saldo = saldo + (pos[3] - valor)/5
        global pos[4] = pos[4] - 1
      end
      if pos[4] == 0
        pos = [0, 0, 0, 0]
      end
    else
      global pos = [1, "Compra", (pos[3] * pos[4] + valor * volume)/(pos[4] + volume), pos[4] + volume]
    end
  end
end

function venda(valor, volume = 1)
  if pos[1] !== 1
    global pos = [1, "Venda", valor, volume]
  else
    if pos[2] == "Compra"
      for i in 1:volume
        if pos[4] == 0
          global pos = [1, "Venda", valor, volume-i+1]
          break
        end
        global saldo = saldo + (valor - pos[3])/5
        global pos[4] = pos[4] - 1
      end
      if pos[4] == 0
        pos = [0, 0, 0, 0]
      end
    else
      global pos = [1, "Venda", (pos[3] * pos[4] + valor * volume)/(pos[4] + volume), pos[4] + volume]
    end
  end
end

function backtest(robo, ticks, candles)
  global saldo, pos = 0, [0, 0, 0, 0]
  include(joinpath(@__DIR__, "$(robo).jl"))
  entradas = X13(candles)
  global saldo, start = 0, 0

  i = 1
  for i in 1:size(ticks, 1)
    if entradas[1][1] == Dates.DateTime(parse(Int, split(ticks[i,1], ".")[1]),
                                        parse(Int, split(ticks[i,1], ".")[2]),
                                        parse(Int, split(ticks[i,1], ".")[3]),
                                        Dates.hour(ticks[i,2]),
                                        Dates.minute(ticks[i,2]))
      global start = i
      break
    end
  end
  last2 = ticks[start, 5]

  if entradas[1][2] == "Compra"
    compra(last2)
    global sl, tp = (last2 - 100, 1), (last2 + 200, 1)
  elseif entradas[1][2] == "Venda"
    venda(last2)
    global sl, tp = (last2 + 100, 1), (last2 - 200, 1)
  end
  deleteat!(entradas, 1)

  for i in start:size(ticks, 1)
    if pos[1] == 1
      if pos[2] == "Compra"
        if ticks[i, 5] >= tp[1]
          venda(tp[1], tp[2])
        elseif ticks[i, 5] <= sl[1]
          venda(sl[1], sl[2])
        end
      elseif pos[2] == "Venda"
        if ticks[i, 5] <= tp[1]
          compra(tp[1], tp[2])
        elseif ticks[i, 5] >= sl[1]
          compra(sl[1], sl[2])
        end
      end
    end

    if Dates.DateTime(parse(Int, split(ticks[i,1], ".")[1]),
                      parse(Int, split(ticks[i,1], ".")[2]),
                      parse(Int, split(ticks[i,1], ".")[3]),
                      Dates.hour(ticks[i,2]),
                     (Dates.minute(ticks[i,2]) + 2) % 60) == entradas[1][1]
      last2 = ticks[i, 5]
      if entradas[1][2] == "Compra"
        compra(last2)
        sl, tp = (last2 - 100, 1), (last2 + 200, 1)
      elseif entradas[1][2] == "Venda"
        venda(last2)
        sl, tp = (last2 + 100, 1), (last2 - 200, 1)
      end
      deleteat!(entradas, 1)
      if size(entradas)[1] == 0
        break
      end
    end
  end
  return saldo
end
