function ema(arr, n, wilder = false)
    if n == 1
      return arr[1]
    else
      if wilder
        k = 1/n
      else
        k = 2/(n+1)
      end
      m = n
      return arr[n]*k + ema(arr, n - 1, wilder)*(1 - k)
    end
  end