defmodule Numbers.CLI do
    def main(argv) do
        IO.puts("Numbers module tester")
        res = Numbers.is_kaprekar( String.to_integer( Enum.at(argv,0) ) )
        IO.puts(res)
    end
end