defmodule Poker do
  @moduledoc """
  Documentation for Poker.
  """

  def check_high_card(poker_hand) do
  end

  def check_pair(poker_hand) do
  end

  def check_two_pairs(poker_hand) do
  end

  def check_three_of_a_kind(poker_hand) do
  end

  def check_straight(poker_hand) do
  end

  def check_flush(poker_hand) do
  end

  def check_full_house(poker_hand) do
  end

  def check_four_of_a_kind(poker_hand) do
  end

  def check_straight_straight_flush(poker_hand) do
  end

  def compare_hands(hand1, hand2) do
    hand1_highest = getHighest(hand1)
    hand2_highest = getHighest(hand2)

    if hand1_highest == hand2_highest do
    end
  end
end
