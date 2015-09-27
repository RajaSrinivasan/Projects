import Numbers
defmodule NumbersTest do
  use ExUnit.Case
  test "the truth" do
    IO.puts( digits(22) )
    assert [2,2] = digits(22)
    assert :true = is_kaprekar(4879)
    assert :false = is_kaprekar(2000)
  end
end
