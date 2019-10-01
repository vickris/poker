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

  def check_straight_flush(poker_hand) do
    poker_hand
    |> String.split()
    |> Enum.reduce(%{vals: [], suites: []}, fn x, acc ->
      x |> String.codepoints() |> separate_values_from_suits(acc)
    end)
  end

  def separate_values_from_suits([val, suit], acc) do
    if !Enum.member?(acc.suites, suit), do: %{acc | suites: [suit | acc.suites]}
    if !Enum.member?(acc.vals, val), do: %{acc | vals: [val | acc.vals]}
    # if !Enum.member?(acc.suites, suit), do: %{acc | suites: [suit | acc.suites]}
  end

  def compare_hands(hand1, hand2) do
    hand1_highest = get_highest(hand1)
    hand2_highest = get_highest(hand2)

    if hand1_highest == hand2_highest do
    end
  end

  def get_highest(hand) do
    hand
    |> check_straight_flush
  end
end
