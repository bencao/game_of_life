defmodule Patterns do
  @doc """
  Load specific `pattern` into engine
  """
  def load(pattern) do
    Engine.API.load(pattern.to_list)
  end
end
