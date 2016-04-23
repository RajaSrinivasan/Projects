import Temperature

IO.puts("Water freezes at ")
IO.puts( centigrade(32.0) )
IO.puts(" deg C")

IO.puts("Water becomes steam at ")
IO.puts( fahrenheit(100.0) )
IO.puts(" deg F")

goodlow=60      # deg Fahrenheit
goodhigh=75     # deg Fahrenheit

goodlowc=trunc(centigrade(goodlow))
goodhighc=round(centigrade(goodhigh))

IO.puts("Best climate for me is from #{goodlowc} to #{goodhighc} deg C")

humanavgtempc = 37
humanavgtempf = fahrenheit(humanavgtempc)
IO.puts("Human body temperature average is #{humanavgtempc} deg C or #{humanavgtempf} deg F")

lowesttempc = -89.2
lowesttempf = round(fahrenheit(lowesttempc))

IO.puts("Lowest temperature on earth is #{lowesttempc} deg C or #{lowesttempf} deg F")
