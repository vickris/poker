defmodule PokerTest do
  use ExUnit.Case
  doctest Poker

  test "high card wins when no higher category is available" do
    assert Poker.compare_hands("2H 3D 5S 9C KD", "2C 3H 4S 8C AH") == "White wins - A"
  end

  describe "pair" do
    test "highest pair wins" do
      assert Poker.compare_hands("2H 3D 3S 9C KD", "2C 4H 4S 8C AH") == "White wins - 4"
    end

    test "tie" do
      assert Poker.compare_hands("2C 4H 4S 8C AH", "2C 4H 4S 8C AH") == "Tie"
    end
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

    test "tie" do
      assert Poker.compare_hands("2H 2D 4S 4C KD", "2H 2D 4S 4C KD") == "Tie"
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

    test "tie" do
      assert Poker.compare_hands("2C 3H 4S 8C AH", "2C 3H 4S 8C AH") == "Tie"
    end
  end

  describe "flush" do
    test "ranked using highest card" do
      assert Poker.compare_hands("2H 4H 8H 9H KH", "2H 4H 6H 9H AH") == "White wins - A"
    end

    test "wins over pair" do
      assert Poker.compare_hands("2H 3D 3S 9C KD", "2H 4H 3H 8H AH") == "White wins - flush"
    end

    test "tie" do
      assert Poker.compare_hands("2H 4H 8H 9H KH", "2H 4H 8H 9H KH") == "Tie"
    end
  end

  describe "four of a kind" do
    test "ranked using val of 4 cards" do
      assert Poker.compare_hands("2H 2D 2S 2C KD", "3H 3H 3H 3H AH") == "White wins - 3"
    end

    test "wins over pair" do
      assert Poker.compare_hands("2H 2D 2S 2C KD", "2H 4H 3H 8H AH") ==
               "Black wins - four of a kind"
    end

    test "tie" do
      assert Poker.compare_hands("2H 2D 2S 2C KD", "2H 2D 2S 2C KD") == "Tie"
    end
  end

  describe "full house" do
    test "ranked using val of the 3 cards" do
      assert Poker.compare_hands("4H 4D 4S 5C 5D", "3C 3H 3S 4C 4H") == "Black wins - 4"
    end

    test "full house wins over flush" do
      assert Poker.compare_hands("2H 4H 3H 8H AH", "3C 3H 3S 4C 4H") == "White wins - full house"
    end
  end

  describe "straight flush" do
    test "ranked by highest card" do
      assert Poker.compare_hands("4D 5D 6D 7D KD", "4D 5D 6D 7D AD") == "White wins - A"
    end

    test "wins over full house" do
      assert Poker.compare_hands("4D 5D 6D 7D 8D", "3C 3H 3S 4C 4H") ==
               "Black wins - straight flush"
    end
  end

  test "Black hand needs 5 cards" do
    assert Poker.compare_hands("4D 5D 6D 7D", "4D 5D 6D 7D AD") ==
             "Black Poker hand needs to have 5 cards for scoring purposes"
  end

  test "White hand needs 5 cards" do
    assert Poker.compare_hands("4D 5D 6D 7D 8D", "4D 5D 6D 7D") ==
             "White poker hand needs to have 5 cards for scoring purposes"
  end
end
