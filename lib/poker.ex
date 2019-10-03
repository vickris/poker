defmodule Poker do
  @moduledoc """
  Documentation for Poker.
  """

  @val_ranking %{
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

  @hand_ranking %{
    "high card" => 0,
    "pair" => 1,
    "two pairs" => 2,
    "three of a kind" => 3,
    "straight" => 4,
    "flush" => 5,
    "full house" => 6,
    "four of a kind" => 7
  }

  def check_three_of_a_kind(occurences) do
    if Enum.member?(occurences, 1) do
      {:ok, "two pairs"}
    else
      {:ok, "three of a kind"}
    end
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
        _ -> {:ok, "high card"}
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
    IO.inspect(hand1_type)
    IO.inspect(hand2_type)

    return_val =
      case hand1_type do
        hand2_type ->
          run_highest_card_check(hand1_type_and_vals.values, hand2_type_and_vals.values)

        _ ->
          run_type_funnel(hand1_type_and_vals.type, hand2_type_and_vals.type)
      end

    return_val
    |> formatOutput
  end

  def formatOutput(%{hand1: value}) do
    "Black wins - #{value}"
  end

  def formatOutput(%{hand2: value}) do
    "White wins - #{value}"
  end

  def formatOutput(_) do
    "Tie"
  end

  def run_type_funnel({:ok, hand1_type}, {:ok, hand2_type}) do
    IO.puts("Run type funnel")

    cond do
      @hand_ranking[hand1_type] > @hand_ranking[hand1_type] -> %{hand1: hand1_type}
      @hand_ranking[hand2_type] > @hand_ranking[hand2_type] -> %{hand2: hand2_type}
      true -> %{}
    end
  end

  def run_highest_card_check(hand1_vals, hand2_vals) do
    0..4
    |> Enum.reduce_while(%{}, fn x, acc ->
      current_val_hand1 = hand1_vals |> Enum.at(x)
      current_val_hand2 = hand2_vals |> Enum.at(x)

      cond do
        @val_ranking[current_val_hand1] > @val_ranking[current_val_hand2] ->
          {:halt, acc |> Map.put_new(:hand1, current_val_hand1)}

        @val_ranking[current_val_hand2] > @val_ranking[current_val_hand1] ->
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
