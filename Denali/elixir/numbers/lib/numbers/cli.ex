defmodule Numbers.CLI do

    def parse_args(argv) do
        parse = OptionParser.parse( argv , switches: [ p: :boolean , k: :boolean ] ,
                                           aliases:  [ p: :perfect , k: :kaprekar ] )
    end

    def main(argv) do
        IO.puts("Numbers module tester")

        res = Numbers.is_kaprekar( String.to_integer( Enum.at(argv,0) ) )
        IO.puts(res)
    end
end