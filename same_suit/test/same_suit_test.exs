defmodule SameSuitTest do
  use ExUnit.Case
  doctest SameSuit

  test "greets the world" do
    assert SameSuit.hello() == :world
  end
end
