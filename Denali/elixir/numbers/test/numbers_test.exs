import Numbers
defmodule NumbersTest do
  use ExUnit.Case
  test "Digit separation" do
      assert [8,6,8,9] = digits(8689)
      assert [1,0,5,6] = digits(1056)
      assert [5,2,2] = digits(522)
  end
  test "Factorization tests" do
      assert [1,2,3,6] = factorize(6)
      assert [1,2,5,10] = factorize(10)
      assert [1,13] = factorize(13)
      assert [1,907] = factorize(907)
  end
  test "Kaprekar algorithm" do
    IO.puts( digits(22) )
    assert [2,2] = digits(22)
    assert :true = is_kaprekar(4879)
    assert :false = is_kaprekar(2000)
  end
  test "Perfect Numbers" do
      assert :true = is_perfect(6)
      assert :true = is_perfect(28)
      assert :true = is_perfect(8128)
      assert :false = is_perfect(25)
      assert :true = is_perfect(33550336)
  end
  test "Prime Numbers" do
      assert :true = is_prime(13)
      assert :true = is_prime(32582657)
      assert :false = is_prime(32582659)
  end
end
