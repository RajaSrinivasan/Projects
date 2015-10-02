import Numbers
defmodule NumbersTest do
  use ExUnit.Case
  test "Digit separation" do
      assert [8,6,8,9] = digits(8689)
      assert [1,0,5,6] = digits(1056)
      assert [5,2,2] = digits(522)
  end
  
  test "Kaprekar algorithm" do
    IO.puts( digits(22) )
    assert [2,2] = digits(22)
    assert :true = is_kaprekar(4879)
    assert :false = is_kaprekar(2000)
  end
end
