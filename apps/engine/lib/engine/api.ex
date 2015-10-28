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

  @doc """
  Add listener with `name`, each time world changes the `callback` will be called
  """
  def add_listener(name, callback) when is_atom(name) do
    GenEvent.call(
      Application.get_env(:engine, :event_manager_pid),
      Engine.MutationHandler,
      {:add_listener, name, callback}
    )
  end

  @doc """
  Remove listener with `name`
  """
  def remove_listener(name) when is_atom(name) do
    GenEvent.call(
      Application.get_env(:engine, :event_manager_pid),
      Engine.MutationHandler,
      {:remove_listener, name}
    )
  end
end
