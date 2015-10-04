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
    
    # Factorize a number
    def factorize(num) when num > 1 do
        r=Enum.reduce(1..trunc(num/2) ,
                           fn(x,fac) ->
                             if :true == is_factor(num,x) do
                                fac = List.flatten( [fac , x ] )
                             end
                             fac
                           end  )
        List.flatten( [r , num] )
    end

    def factorize(num) when num == 1 do
        [1]
    end
    
    def is_factor(num,x) do
        if rem(num,x) == 0 do
           :true
        else
           :false
        end
    end

    def number_table(num) do
        acc=0
        Enum.reduce( 1..num ,
                     acc ,
                     fn(x , acc) ->
                         IO.write("#{x}\t")
                         if (:true == is_prime(x)) do
                            IO.write("\tprime")
                         else
                            IO.write("\t\t")
                         end
                         if (:true == is_perfect(x)) do
                              IO.write("\tperfect")
                         end
                         IO.puts("")
                     end
                     )
    end

    # Is this a perfect number?
    def is_perfect(num) do
        fac=factorize(num)
        acc=0
        sumoffactors = Enum.reduce(fac , acc , fn(x,acc) ->
                                    acc = acc + x
                                    acc
                                end )
        if num*2 == sumoffactors do
           :true
        else
           :false
        end
    end

    # Is this a prime number
    def is_prime(num) when num > 2 do
        if even(num) do
           :false
        end
        fac = factorize(num)
        if length(fac) == 2 do
           :true
        else
           :false
        end
    end
    def is_prime(num) when num == 1 do
       :false
    end
    def is_prime(num) when num == 2 do
       :true
    end
    # Is the given number a Kaprekar number?
    # Ref: https://en.wikipedia.org/wiki/Kaprekar_number
    def is_kaprekar(num) do
        numsq = num * num
        numsqdigs = digits(numsq)
        Enum.any?(1..length(numsqdigs)-1 , fn(x) -> 
                                              if :true == _kaprekar(num,numsqdigs,x) do 
                                                 :true
                                              else
                                                 :false
                                              end 
                                                 end)
    end
    
    def _kaprekar(num,numdigs,n) do
        {a,b}=Enum.split(numdigs,n)
        anum=decimal(a)
        bnum=decimal(b)
        if anum+bnum == num do
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

