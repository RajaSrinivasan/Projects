defmodule Diab do
   conversion=0.055555555555556
   def mmoll(mgdl) do
       mgdl * 0.055555555555556
   end
   def mgdl( mmoll ) do
       mmoll / 0.055555555555556
   end
end
