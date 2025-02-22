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
