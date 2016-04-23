defmodule Temperature do
   def centigrade(f) do
       (100.0/180.0)*(f-32.0)
   end
   def fahrenheit(c) do
       32.0 + (180.0/100.0) * c
   end
end