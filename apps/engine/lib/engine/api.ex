defmodule Engine.API do
  @doc """
  Load `matrix` into engine
  """
  def load(matrix) do
    {:ok, new_world} = Engine.World.new(matrix)
    Engine.Judge.goto(
      Application.get_env(:engine, :judge_pid),
      new_world,
      true
    )
  end

  @doc """
  Inspect current world status
  """
  def inspect do
    Engine.Judge.inspect Application.get_env(:engine, :judge_pid)
  end
end
