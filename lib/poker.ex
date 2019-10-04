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
    if Enum.member?(occurences, 3) do
      {:ok, "three of a kind"}
    else
      {:ok, "two pairs"}
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
        {1, 5} -> confirm_type(5, values)
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

  def confirm_type(5, values) do
    incrementing_count =
      1..4
      |> Enum.reduce_while(0, fn index, acc ->
        current = @val_ranking[Enum.at(values, index)]
        previous = @val_ranking[Enum.at(values, index - 1)]

        if previous > current, do: {:cont, acc + 1}, else: {:halt, acc}
      end)

    case incrementing_count do
      4 -> {:ok, "straight flush"}
      _ -> {:ok, "flush"}
    end
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
      cond do
        hand1_type == hand2_type ->
          run_highest_card_check(hand1_type_and_vals, hand2_type_and_vals)

        true ->
          run_type_funnel(hand1_type, hand2_type)
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
    cond do
      @hand_ranking[hand1_type] > @hand_ranking[hand2_type] -> %{hand1: hand1_type}
      @hand_ranking[hand2_type] > @hand_ranking[hand1_type] -> %{hand2: hand2_type}
      true -> %{}
    end
  end

  def highest_card_three_of_a_kind(hand1, hand2) do
    hand1_mappings =
      hand1
      |> Enum.reduce(%{}, fn x, acc -> Map.update(acc, x, 1, &(&1 + 1)) end)
      |> Enum.reduce(%{1 => [], 3 => []}, fn {val, count}, acc ->
        Map.put(acc, count, [val | acc[count]])
      end)

    hand2_mappings =
      hand2
      |> Enum.reduce(%{}, fn x, acc -> Map.update(acc, x, 1, &(&1 + 1)) end)
      |> Enum.reduce(%{1 => [], 3 => []}, fn {val, count}, acc ->
        Map.put(acc, count, [val | acc[count]])
      end)

    return_val =
      hand1_mappings
      |> compare_pairs(hand2_mappings)
  end

  def highest_card_four_of_a_kind(hand1, hand2) do
    hand1_mappings =
      hand1
      |> Enum.reduce(%{}, fn x, acc -> Map.update(acc, x, 1, &(&1 + 1)) end)
      |> Enum.reduce(%{1 => [], 4 => []}, fn {val, count}, acc ->
        Map.put(acc, count, [val | acc[count]])
      end)

    hand2_mappings =
      hand2
      |> Enum.reduce(%{}, fn x, acc -> Map.update(acc, x, 1, &(&1 + 1)) end)
      |> Enum.reduce(%{1 => [], 4 => []}, fn {val, count}, acc ->
        Map.put(acc, count, [val | acc[count]])
      end)

    return_val =
      hand1_mappings
      |> compare_pairs(hand2_mappings)
  end

  def highest_card_full_house(hand1, hand2) do
    hand1_mappings =
      hand1
      |> Enum.reduce(%{}, fn x, acc -> Map.update(acc, x, 1, &(&1 + 1)) end)
      |> Enum.reduce(%{2 => [], 3 => []}, fn {val, count}, acc ->
        Map.put(acc, count, [val | acc[count]])
      end)

    hand2_mappings =
      hand2
      |> Enum.reduce(%{}, fn x, acc -> Map.update(acc, x, 1, &(&1 + 1)) end)
      |> Enum.reduce(%{2 => [], 3 => []}, fn {val, count}, acc ->
        Map.put(acc, count, [val | acc[count]])
      end)

    return_val =
      hand1_mappings
      |> compare_pairs(hand2_mappings)
  end

  def highest_pair(hand1, hand2) do
    hand1_mappings =
      hand1
      |> Enum.reduce(%{}, fn x, acc -> Map.update(acc, x, 1, &(&1 + 1)) end)
      |> Enum.reduce(%{1 => [], 2 => []}, fn {val, count}, acc ->
        Map.put(acc, count, [val | acc[count]])
      end)

    hand2_mappings =
      hand2
      |> Enum.reduce(%{}, fn x, acc -> Map.update(acc, x, 1, &(&1 + 1)) end)
      |> Enum.reduce(%{1 => [], 2 => []}, fn {val, count}, acc ->
        Map.put(acc, count, [val | acc[count]])
      end)

    return_val =
      hand1_mappings
      |> compare_pairs(hand2_mappings)
  end

  def get_highest_hand(hand1, hand2, "pair") do
    highest_pair(hand1, hand2)
  end

  def get_highest_hand(hand1, hand2, "two pairs") do
    highest_pair(hand1, hand2)
  end

  def get_highest_hand(hand1, hand2, "three of a kind") do
    highest_card_three_of_a_kind(hand1, hand2)
  end

  def get_highest_hand(hand1, hand2, "four of a kind") do
    highest_card_four_of_a_kind(hand1, hand2)
  end

  def get_highest_hand(hand1, hand2, "full house") do
    highest_card_full_house(hand1, hand2)
  end

  def compare_pairs(hand1_mappings, hand2_mappings) do
    hand1_mappings
    |> Enum.reverse()
    |> Enum.reduce_while(%{}, fn {k, _values}, acc ->
      hand_and_card = get_highest_card(hand1_mappings[k], hand2_mappings[k])
      key_count = hand_and_card |> Map.keys() |> Enum.count()

      if key_count == 0 do
        {:cont, acc}
      else
        {:halt,
         acc
         |> Map.put_new(hand_and_card |> Map.keys() |> hd, hand_and_card |> Map.values() |> hd)}
      end
    end)
  end

  def get_highest_card(hand1, hand2) do
    last_index = Enum.count(hand1) - 1

    0..last_index
    |> Enum.reduce_while(%{}, fn x, acc ->
      current_val_hand1 = hand1 |> Enum.at(x)
      current_val_hand2 = hand2 |> Enum.at(x)

      cond do
        @val_ranking[current_val_hand1] > @val_ranking[current_val_hand2] ->
          {:halt, acc |> Map.put_new(:hand1, current_val_hand1)}

        @val_ranking[current_val_hand2] > @val_ranking[current_val_hand1] ->
          {:halt, acc |> Map.put_new(:hand2, current_val_hand2)}

        true ->
          {:cont, acc}
      end
    end)
  end

  def run_highest_card_check(hand1, hand2) do
    hand1_vals = hand1.values
    hand2_vals = hand2.values
    type = hand1.type

    case type do
      {:ok, "pair"} -> get_highest_hand(hand1_vals, hand2_vals, "pair")
      {:ok, "two pairs"} -> get_highest_hand(hand1_vals, hand2_vals, "two pairs")
      {:ok, "three of a kind"} -> get_highest_hand(hand1_vals, hand2_vals, "three of a kind")
      {:ok, "four of a kind"} -> get_highest_hand(hand1_vals, hand2_vals, "four of a kind")
      {:ok, "full house"} -> get_highest_hand(hand1_vals, hand2_vals, "full house")
      _ -> get_highest_card(hand1_vals, hand2_vals)
    end
  end

  def get_highest(hand) do
    hand
    |> get_suites_and_vals
    |> get_type_and_values
  end
end
