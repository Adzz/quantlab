defmodule Quantlab do
  @moduledoc """
  """
  alias NimbleCSV.RFC4180, as: CSV

  @doc """
  Summarises the provided list of trades
  """
  # <symbol>,<MaxTimeGap>,<Volume>,<WeightedAveragePrice>,<MaxPrice>
  def trade_summaries(path) do
    Quantlab.File.stream!(path, :line)
    |> CSV.parse_stream()
    |> Enum.reduce(%{}, fn [timestamp, symbol, quantity, price], summaries ->
      # Cast data
      timestamp = cast_int(timestamp)
      price = cast_int(price)
      quantity = cast_int(quantity)

      symbol_summary = Map.get(summaries, symbol, %{})

      symbol_summary =
        symbol_summary
        |> update_max_time_gap(timestamp)
        |> update_volume(quantity)
        # These are used for weighted_average_price at the end.
        |> update_total_price_and_quantity(quantity, price)
        |> update_max_price(price)

      Map.put(summaries, symbol, symbol_summary)
      # |> IO.inspect(limit: :infinity, charlists: :as_lists, label: "")
    end)
  end

  defp cast_int(input) do
    # We raise because we do not expect errors in the input at the moment.
    {int, ""} = Integer.parse(input)
    int
  end

  @doc """
  Updates a symbol summary with the largest yet seen gap between consecutive trades.
  """
  def update_max_time_gap(symbol_summary, current_timestamp) do
    previous_timestamp = Map.get(symbol_summary, :previous_timestamp, current_timestamp)
    previous_gap = Map.get(symbol_summary, :max_time_gap, 0)
    current_gap = abs(current_timestamp - previous_timestamp)

    symbol_summary
    |> Map.put(:previous_timestamp, current_timestamp)
    |> Map.put(:max_time_gap, max(previous_gap, current_gap))
  end

  @doc """
  Updates a symbol summary with the provided quantity
  """
  def update_volume(symbol_summary, quantity) do
    current_quantity = Map.get(symbol_summary, :volume, 0)
    Map.put(symbol_summary, :volume, quantity + current_quantity)
  end

  @doc """
  Weighted average price is the average price per unit traded _not_ per trade. Result is truncated
  to whole numbers.

  ### Example:

  20 shares of aaa @ 18
  5 shares of aaa @ 7
  Weighted Average Price = ((20 * 18) + (5 * 7)) / (20 + 5) = 15

  """
  def update_total_price_and_quantity(symbol_summary, quantity, price) do
    total_quantity = Map.get(symbol_summary, :total_quantity, 0)
    total_price = Map.get(symbol_summary, :total_price, 0)

    symbol_summary
    |> Map.put(:total_quantity, total_quantity + quantity)
    |> Map.put(:total_price, total_price + price * quantity)
  end

  @doc """
  Adds the maximum price to the symbol_summary
  """
  def update_max_price(symbol_summary, price) do
    current_max = Map.get(symbol_summary, :max_price, price)
    Map.put(symbol_summary, :max_price, max(current_max, price))
  end
end
