defmodule Numbers do
    def digits(num) do
        _digits(num)
    end

    def displaydigs([h|t]) do
        IO.puts(h)
        displaydigs(t)
    end
    def displaydigs([]) do
    end
    def _digits(argdig) when argdig <= 9 do
        [argdig]
    end    
    def _digits(argdig) when argdig > 9 do
        List.flatten([ _digits(div(argdig,10)) ,rem(argdig,10)])
    end
end
