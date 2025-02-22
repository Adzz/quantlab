defmodule Quantlab.FileBehaviour do
  @typep encoding_mode() ::
           :utf8
           | {:encoding,
              :latin1
              | :unicode
              | :utf8
              | :utf16
              | :utf32
              | {:utf16, :big | :little}
              | {:utf32, :big | :little}}
  @typep read_offset_mode() :: {:read_offset, non_neg_integer()}
  @typep stream_mode() ::
           encoding_mode()
           | read_offset_mode()
           | :append
           | :compressed
           | :delayed_write
           | :trim_bom
           | {:read_ahead, pos_integer() | false}
           | {:delayed_write, non_neg_integer(), non_neg_integer()}

  @typep mode() ::
           :append
           | :binary
           | :charlist
           | :compressed
           | :delayed_write
           | :exclusive
           | :raw
           | :read
           | :read_ahead
           | :sync
           | :write
           | {:read_ahead, pos_integer()}
           | {:delayed_write, non_neg_integer(), non_neg_integer()}
           | encoding_mode()
  @callback stream!(Path.t() | String.t(), :line | pos_integer() | [stream_mode()]) ::
              File.Stream.t()

  @callback write!(Path.t(), iodata(), [mode()]) :: :ok
end
