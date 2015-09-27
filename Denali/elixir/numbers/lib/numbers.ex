defmodule Numbers do

    def odd(num) do
        if rem(num,2) == 1 do
           :true
        else
           :false
        end
    end
    
    def even(num) do
        not odd(num)
    end
    
    # Given a number generate a list with each member
    # being a decimal digit of the number
    def digits(num) do
        _digits(num)
    end

    def displaydigs([h|t]) do
        IO.puts(h)
        displaydigs(t)
    end
    
    def displaydigs([]) do
    end
    
    # given a list with each decimal digit as an element
    # compute the value
    def decimal(num) do
        if length(num) == 1 do
           Enum.at(num,0)
        else
            [h|t] = num
            n1=h
            n2=decimal(t)
            trunc(n1*:math.pow(10,length(t)) + n2)
        end
    end

    # Is the given number a Kaprekar number?
    # Ref: https://en.wikipedia.org/wiki/Kaprekar_number
    def is_kaprekar(num) do
        numsq = num * num
        numsqdigs = digits(numsq)
        lsqdigs = Enum.slice( numsqdigs , 0 , trunc(length(numsqdigs)/2))
        rsqdigs = Enum.slice( numsqdigs , trunc(length(numsqdigs)/2) , round(length(numsqdigs)/2) )
        lsnum=decimal(lsqdigs)
        rsnum=decimal(rsqdigs)
        if (rsnum > 0) and (lsnum > 0) do
           if (rsnum+lsnum) == num do
           	  :true
           else
              :false
           end   
        else
        	:false
        end	
    end
    
    # Private Implementation functions
    def _digits(argdig) when argdig <= 9 do
        [argdig]
    end   
     
    def _digits(argdig) when argdig > 9 do
        List.flatten([ _digits(div(argdig,10)) ,rem(argdig,10)])
    end
end

