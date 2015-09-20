IO.puts( String.capitalize("hello srini") )
{dad, mom, son, daughter} = {"Raja", "Gita" , "Rajiv" , "Ranjana"}
IO.puts(dad)
IO.puts(mom)
IO.puts(son)
IO.puts(daughter)
{:ok , inpfile} = File.open("hello.exs", [:read, :utf8])
IO.puts(IO.readline(inpfile))

File.close inpfile

