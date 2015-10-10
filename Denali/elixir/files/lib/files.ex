defmodule Files do
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
                       IO.puts("File #{fname} Algorithm #{alg} Digest: #{mydigest}")
       end
   end

   def digest_tasks(fname) do
       algorithms=[:md5,:ripemd160,:sha,:sha224,:sha256,:sha384,:sha512]
       alg=0
       Enum.reduce(:crypto.supports, alg ,
                               fn(x,acc) ->
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
