defmodule PokerTest do
  use ExUnit.Case
  doctest Poker

  test "high card wins when no higher category is available" do
    assert Poker.compare_hands("2H 3D 5S 9C KD", "2C 3H 4S 8C AH") == "White wins - A"
  end

  test "highest pair wins" do
    assert Poker.compare_hands("2H 3D 3S 9C KD", "2C 4H 4S 8C AH") == "White wins - 4"
  end

  test "hand with second highest val to pair wins for tie" do
    assert Poker.compare_hands("2H 3D 3S 9C KD", "2C 3H 3S 8C AH") == "White wins - A"
  end

  test "straight wins over pair" do
    assert Poker.compare_hands("2H 3D 3S 9C KD", "2C 3H 4S 8C AH") == "White wins - straight"
  end
end
