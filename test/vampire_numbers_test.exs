defmodule VampireNumbersTest do
  use ExUnit.Case
  doctest VampireNumbers

  # test "greets the world" do
  #   assert VampireNumbers.hello() == :world
  # end

  doctest VampireCalc

  test "finds a number with 2 fangs" do
    assert VampireCalc.find_fangs(1260) == {:ok, 1260, [21, 60]}
  end

  test "finds anoth number with 2 fangs" do
    assert VampireCalc.find_fangs(1395) == {:ok, 1395, [15, 93]}
  end

  test "finds a number with 4 fangs" do
    assert VampireCalc.find_fangs(125460) == {:ok, 125460, [204, 615, 246, 510]}
  end

  test "finds a valid number with no fangs" do
    assert VampireCalc.find_fangs(1234) == {:not_found, 0, []}
  end

  test "ignores a number with odd digits" do
    assert VampireCalc.find_fangs(123) == {:not_found, 0, []}
  end

  test "ignores a number with 2 digits or less" do
    assert VampireCalc.find_fangs(12) == {:not_found, 0, []}
  end

end
