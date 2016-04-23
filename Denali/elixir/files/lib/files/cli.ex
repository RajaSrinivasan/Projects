defmodule Files.CLI do

   def main(argv) do
     argv
       |> parse_args
       |> process
   end
   def parse_args(argv) do
       {keywords,remarg,errors}=OptionParser.parse(argv,   switches: [ help: :boolean ,
                                                                       linecount: :string ,
                                                                       digest: :string ],

                                      aliases:  [[ h:    :help ] ,
                                                 [ c:    :linecount ] ,
                                                 [ g:    :digest] ])

       case keywords do
         [help: true] -> :help
         [linecount: stdir] -> { :linecount , stdir }
         [digest: digfile] ->  { :digest , digfile }
         _ -> :help
       end
   end

   def process(:help) do
     IO.puts """
     usage: files <dir>
     """
     System.halt(0)
   end

   def process({:linecount,stdir}) do
       dir = stdir
       if File.regular?(dir) do
          Files.linecount(dir)
          |> IO.puts
       else
          Files.linecountdir(dir)
       end
   end

   def process({:digest,filename}) do
     if File.regular?(filename) do
        Files.digest(filename)
        |> IO.puts
     else
       IO.puts "#{filename} is not a regular file to digest!"
     end
   end
end
