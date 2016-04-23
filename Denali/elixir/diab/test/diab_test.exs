import Diab
defmodule DiabTest do
  use ExUnit.Case
  test "Conversion of 1 mgdl " do
    assert mmoll(1.0) == 0.055555555555556
    assert mgdl(0.055555555555556) == 1.0
  end
end
