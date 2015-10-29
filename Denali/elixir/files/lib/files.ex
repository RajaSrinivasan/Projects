defmodule Files do

   def linecount(filename) do
       f=File.stream!(filename,[:read],:line)
       lines=0
       lines=Enum.reduce( f , lines ,
                    fn(x,lc) ->
                        lc=lc+1
                        lc
                        end)
       File.close f
       lines
   end

   def linecount(filename, table) do
       lc=linecount(filename)
       ext=Path.extname(filename)
       if Dict.has_key?(table,ext) do
          IO.puts(ext)
          IO.puts("already exists")
       else
          Dict.put(table,ext,lc)
       end
   end

   def show(filename) do
       f=File.stream!(filename,[:read],:line)
       linenum=0
       Enum.reduce(f, linenum , fn(x,lnum) ->
                          lnum = lnum + 1
                          :io.format("~4B",[lnum])
                          IO.write(" : ")
                          IO.write(x)
                          lnum
                      end)
   end

   def digest_task (alg) do
       # IO.puts("Will use algorithm #{alg}")
       receive do
          fname ->

                       mydigest = digest(fname,alg)
                       IO.puts("Algorithm #{alg} Digest: #{mydigest}")
       end
   end

   def digest_tasks(fname) do
       algorithms = :crypto.supports()[:hashs]
       alg=0
       Enum.reduce(algorithms, alg ,
                               fn(x,_) ->
                                   pid=spawn(Files,:digest_task,[x])
                                   send(pid,fname)
                               end
                               )
   end

   def digest(filename) do
       digest(filename,:md5)
   end
   
   def digest(filename,alg) do
       fcontents=File.read!(filename)
       mydigest = :crypto.hash_init(alg)
       mydigest = :crypto.hash_update(mydigest,fcontents)
       :crypto.hash_final(mydigest) |> Base.encode16 |> String.downcase
   end

end
