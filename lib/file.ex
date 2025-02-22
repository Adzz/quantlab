defmodule Quantlab.File do
  @behaviour Quantlab.FileBehaviour
  @file_module Application.compile_env!(:quantlab, :file_module)

  @impl Quantlab.FileBehaviour
  def stream!(path, line_or_bytes_modes) do
    @file_module.stream!(path, line_or_bytes_modes)
  end

  @impl Quantlab.FileBehaviour
  def write!(path, data, modes) do
    @file_module.write!(path, data, modes)
  end
end
