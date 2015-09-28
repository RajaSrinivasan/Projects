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

    def displaydigs(digs) do
		Enum.each(digs, fn(x) -> IO.puts(x) end)
    end
    
    # given a list with each decimal digit as an element
    # compute the value    
    def decimal(num) do
        Enum.reduce(num, fn(n,acc) -> acc*10 + n end)
    end
    
    
    # Is the given number a Kaprekar number?
    # Ref: https://en.wikipedia.org/wiki/Kaprekar_number
    def is_kaprekar(num) do
        numsq = num * num
        numsqdigs = digits(numsq)
        count=0
        Enum.any?(1..length(numsqdigs)-1 , fn(x) -> 
                                              if :true == _kaprekar(num,numsqdigs,x) do 
                                                 IO.puts("Kaprekar")
                                                 :true
                                              else
                                                 :false
                                              end 
                                                 end)
    end
    
    def _kaprekar(num,numdigs,n) do
        {a,b}=Enum.split(numdigs,n)
        IO.puts("------")
        IO.puts("a")
        displaydigs(a)
        IO.puts("b")
        displaydigs(b)
        anum=decimal(a)
        bnum=decimal(b)
        IO.puts("anum")
        IO.puts(anum)
        IO.puts("bnum")
        IO.puts(bnum)
        IO.puts(anum+bnum)
        if anum+bnum == num do
           IO.puts("Returning true")
           :true
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

