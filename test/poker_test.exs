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

  describe "Two pairs" do
    test "highest pair wins" do
      assert Poker.compare_hands("2H 2D 3S 3C KD", "1C 1H 2S 2C AH") == "Black wins - 3"
    end

    test "with same highest pair ranked by second highest pair" do
      assert Poker.compare_hands("2H 2D 4S 4C KD", "3C 3H 4S 4C AH") == "White wins - 3"
    end

    test "with same pairs ranked by remaining vals" do
      assert Poker.compare_hands("2H 2D 4S 4C KD", "2C 2H 4S 4C AH") == "White wins - A"
    end
  end

  test "three of a kind" do
    assert Poker.compare_hands("4H 4D 4S 5C KD", "3C 3H 3S 4C AH") == "Black wins - 4"
  end

  describe "straight" do
    test "is ranked by highest value assuming values are different" do
      assert Poker.compare_hands("2C 3H 4S 8C AH", "2C 3H 4S 8C KH") == "Black wins - A"
    end

    test "straight wins over pair" do
      assert Poker.compare_hands("2H 3D 3S 9C KD", "2C 3H 4S 8C AH") == "White wins - straight"
    end
  end

  describe "flush" do
    test "ranked using highest card" do
      assert Poker.compare_hands("2H 3H 4H 9H KH", "2H 4H 3H 8H AH") == "White wins - A"
    end

    test "wins over pair" do
      assert Poker.compare_hands("2H 3D 3S 9C KD", "2H 4H 3H 8H AH") == "White wins - flush"
    end
  end

  describe "four of a kind" do
    test "ranked using val of 4 cards" do
      assert Poker.compare_hands("2H 2D 2S 2C KD", "3H 3H 3H 3H AH") == "White wins - 3"
    end
  end
end
