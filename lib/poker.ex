defmodule Poker do
  @moduledoc """
  Documentation for Poker.
  """

  @type_mappings %{
    "2" => 0,
    "3" => 1,
    "4" => 2,
    "5" => 3,
    "6" => 4,
    "7" => 5,
    "8" => 6,
    "9" => 7,
    "T" => 8,
    "J" => 9,
    "Q" => 10,
    "K" => 11,
    "A" => 12
  }

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
    hand1_type = hand1_type_and_vals.type
    hand2_type = hand2_type_and_vals.type

    return_val =
      case(hand1_type) do
        hand2_type ->
          run_highest_card_check(hand1_type_and_vals.values, hand2_type_and_vals.values)

        _ ->
          run_type_funnel(hand1_type_and_vals, hand2_type_and_vals)
      end

    return_val
  end

  def run_type_funnel(hand1, hand2) do
  end

  def run_highest_card_check(hand1_vals, hand2_vals) do
    0..4
    |> Enum.reduce_while(%{}, fn x, acc ->
      current_val_hand1 = hand1_vals |> Enum.at(x)
      current_val_hand2 = hand2_vals |> Enum.at(x)

      cond do
        @type_mappings[current_val_hand1] > @type_mappings[current_val_hand2] ->
          {:halt, acc |> Map.put_new(:hand1, current_val_hand1)}

        @type_mappings[current_val_hand2] > @type_mappings[current_val_hand1] ->
          {:halt, acc |> Map.put_new(:hand1, current_val_hand1)}

        true ->
          {:cont, acc}
      end
    end)
  end

  def get_highest(hand) do
    hand
    |> get_suites_and_vals
    |> get_type_and_values
  end
end
