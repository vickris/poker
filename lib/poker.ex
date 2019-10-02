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

  def check_three_of_a_kind(occurences) do
    if Enum.member?(occurences, 1) do
      {:ok, "two pairs"}
    else
      {:ok, "three of a kind"}
    end
  end

  def check_straight(poker_hand) do
  end

  def check_flush(poker_hand) do
  end

  def check_full_house(poker_hand) do
  end

  def check_four_of_a_kind(occurences) do
    if Enum.member?(occurences, 4) do
      {:ok, "four of a kind"}
    else
      {:ok, "full house"}
    end
  end

  def get_suites_and_vals(poker_hand) do
    poker_hand
    |> String.split()
    |> Enum.reduce(%{vals: [], suites: []}, fn x, acc ->
      x |> String.codepoints() |> separate_values_from_suits(acc)
    end)
  end

  def get_type_and_values(%{suites: suites, vals: values}) do
    suit_count = suites |> Enum.uniq() |> Enum.count()
    value_count = values |> Enum.uniq() |> Enum.count()

    type =
      case {suit_count, value_count} do
        {1, 5} -> {:ok, "straight flush"}
        {_, 2} -> confirm_type(2, values)
        {1, _} -> {:ok, "flush"}
        {_, 5} -> {:ok, "straight"}
        {_, 3} -> confirm_type(3, values)
        {_, 4} -> {:ok, "pair"}
        _ -> {:ok, "High Card"}
      end

    %{type: type, values: values}
  end

  def confirm_type(2, values) do
    values
    |> Enum.reduce(%{}, fn x, acc -> Map.update(acc, x, 1, &(&1 + 1)) end)
    |> Map.values()
    |> check_four_of_a_kind
  end

  def confirm_type(3, values) do
    values
    |> Enum.reduce(%{}, fn x, acc -> Map.update(acc, x, 1, &(&1 + 1)) end)
    |> Map.values()
    |> check_three_of_a_kind
  end

  def separate_values_from_suits([val, suit], acc) do
    %{acc | suites: [suit | acc.suites], vals: [val | acc.vals]}
  end

  def compare_hands(hand1, hand2) do
    hand1_type_and_vals = get_highest(hand1)
    hand2_type_and_vals = get_highest(hand2)

    case hand1_type_and_vals.type do
      hand2_type_and_vals.type ->
        run_highest_card_check(hand1_type_and_vals.values, hand2_type_and_vals.values)

      _ ->
        run_type_funnel(hand1_type_and_vals, hand2_type_and_vals)
    end

    IO.inspect(hand1_highest)
    IO.inspect(hand2_highest)
  end

  def get_highest(hand) do
    hand
    |> get_suites_and_vals
    |> get_type_and_values
  end
end
