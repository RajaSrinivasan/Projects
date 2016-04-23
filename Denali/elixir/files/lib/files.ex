defmodule Files do

   def linecount(filename) do
       f=File.stream!(filename,[:read],:line)
       lines=0
       lines=Enum.reduce( f , lines ,
                    fn(_,lc) ->
                        lc=lc+1
                        lc
                        end)
       File.close f
       lines
   end

   def linecount([],table) do
       table
   end

   def linecount([head | rest], table) do
       tbl=linecount(head,table)
       linecount(rest,tbl)
   end

   def linecount(filename, table) do
       if not File.regular?(filename) do
          # IO.puts("#{filename} is not a regular file")
          linecountdir(filename,table)
       else
         lc=linecount(filename)
         # IO.puts("File #{filename} lines #{lc}")
         ext=Path.extname(filename)
         if Dict.has_key?(table,ext) do
            # IO.puts(ext)
            # IO.puts("already exists")
            {oldfiles,oldval}=Dict.get(table,ext)
            newval=oldval+lc
            Dict.put(table,ext,{oldfiles+1,newval})
         else
            # IO.puts("Adding filetype #{ext} linecount #{lc}")
            Dict.put(table,ext,{1,lc})
         end
       end
   end

   def linecountdir(dirname) do
       table=HashDict.new()
       table=Enum.sort(linecountdir(dirname,table))
       Enum.reduce(table,[],fn(x,_) ->
                          {name,stats}=x
                          {filecount,lines}=stats
                          IO.puts("#{name}\t\t: #{filecount} \t #{lines}")
                          end)
   end
   def linecountdir(dirname,table) do
     {status , files} = File.ls(dirname)
     if status == :ok do
        filelist=Enum.reduce(files,[], fn(x, acc) ->
                                       List.flatten([Path.join(Path.absname(dirname),x) , acc])
                                 end
                            )
        linecount( filelist , table )
     else
        IO.puts("Error for #{dirname} - #{status}")
        table
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
