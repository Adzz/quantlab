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
    |> Enum.reduce(%{}, fn [timestamp, symbol, qty, price], summaries ->
      # Cast data
      timestamp = cast_int(timestamp)
      price = cast_int(price)
      qty = cast_int(qty)

      symbol_summary = Map.get(summaries, symbol, %{})

      symbol_summary =
        symbol_summary
        |> update_max_time_gap(timestamp)

      Map.put(summaries, symbol, symbol_summary)
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
end
