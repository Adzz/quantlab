defmodule QuantlabTest do
  use ExUnit.Case
  import Mox

  setup :verify_on_exit!

  describe "update_max_time_gap/2" do
    test "When symbol summaries is empty we set gap to 0" do
      assert %{max_time_gap: 0} = Quantlab.update_max_time_gap(%{}, 52_924_702)
    end

    test "when there is an existing gap we choose the larger one" do
      result =
        %{}
        |> Quantlab.update_max_time_gap(52_924_702)
        |> Quantlab.update_max_time_gap(52_931_654)

      assert %{max_time_gap: 6952} = result
    end
  end

  describe "update_volume/2" do
    test "adds qty to the volume when there have been no trades" do
      assert %{volume: 2} = Quantlab.update_volume(%{}, 2)
    end

    test "adds qty to the volume when there have been some trades" do
      assert %{volume: 102} = Quantlab.update_volume(%{volume: 100}, 2)
    end
  end

  describe "update_total_price_and_quantity/2" do
    test "We add to total price and quantity when there is nothing" do
      assert %{total_price: 20, total_quantity: 2} =
               Quantlab.update_total_price_and_quantity(%{}, 2, 10)
    end

    test "we add to the totals" do
      assert %{total_price: 120, total_quantity: 3} =
               %{}
               |> Quantlab.update_total_price_and_quantity(2, 10)
               |> Quantlab.update_total_price_and_quantity(1, 100)
    end
  end

  describe "update_max_price/2" do
    test "when there is nothing in the symbol summary" do
      assert %{max_price: 100} = Quantlab.update_max_price(%{}, 100)
    end

    test "when there is a larger price we update" do
      assert %{max_price: 500} =
               Quantlab.update_max_price(%{}, 100) |> Quantlab.update_max_price(500)
    end

    test "when there is a smaller price we dont" do
      assert %{max_price: 500} =
               Quantlab.update_max_price(%{}, 500) |> Quantlab.update_max_price(100)
    end
  end

  describe "Quantlab.trade_summaries/1" do
    test "We summarize a test/fixtures/simple_example_trades.csv" do
      mock_file_stream()
      path = "./test/fixtures/simple_example_trades.csv"

      # expected_output = """
      # aaa,5787,40,1161,1222
      # aab,6103,69,810,907
      # aac,3081,41,559,638
      # """

      Quantlab.trade_summaries(path)
    end
  end

  defp mock_file_stream() do
    expect(Quantlab.FileMock, :stream!, fn path, :line ->
      %File.Stream{
        path: path,
        modes: [:raw, :read_ahead, :binary],
        line_or_bytes: :line,
        raw: true,
        node: :nonode@nohost
      }
    end)
  end
end
