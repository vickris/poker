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

  def get_suites_and_vals(poker_hand) do
    poker_hand
    |> String.split()
    |> Enum.reduce(%{vals: [], suites: []}, fn x, acc ->
      x |> String.codepoints() |> separate_values_from_suits(acc)
    end)
  end

  def check_type(%{suites: suites, vals: values}) do
    suit_count = suites |> Enum.uniq() |> Enum.count()
    value_count = values |> Enum.uniq() |> Enum.count()

    case {suit_count, value_count} do
      {1, 5} -> {:ok, "straight flush"}
      {_, 2} -> {:ok, "four of a kind"}
      {_, 2} -> {:ok, "full house"}
      {1, _} -> {:ok, "flush"}
      {_, 5} -> {:ok, "straight"}
      {_, 3} -> {:ok, "three of a kind"}
      {_, 3} -> {:ok, "two pairs"}
      {_, 4} -> {:ok, "pair"}
      _ -> {:ok, "High Card"}
    end
  end

  def separate_values_from_suits([val, suit], acc) do
    %{acc | suites: [suit | acc.suites], vals: [val | acc.vals]}
  end

  def compare_hands(hand1, hand2) do
    hand1_highest = get_highest(hand1)
    hand2_highest = get_highest(hand2)

    if hand1_highest == hand2_highest do
    end
  end

  def get_highest(hand) do
    hand
    |> get_suites_and_vals
    |> check_type
  end
end
