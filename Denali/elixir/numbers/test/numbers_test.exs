import Numbers
defmodule NumbersTest do
  use ExUnit.Case
  test "the truth" do
    IO.puts( digits(22) )
    assert [2,2] = digits(22)
  end
end
