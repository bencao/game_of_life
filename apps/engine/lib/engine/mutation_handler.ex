defmodule Engine.MutationHandler do
  use GenEvent

  def handle_event({:changed, size, cells}, callbacks) do
    Enum.each callbacks, fn {_name, callback} ->
      try do
        callback.(size, cells)
      rescue
        # TODO error handling
        _ -> :ok
      end
    end

    {:ok, callbacks}
  end

  def handle_call({:add_listener, name, callback}, callbacks) when is_atom(name) do
    {:ok, :ok, Enum.into(%{name: callback}, callbacks)}
  end

  def handle_call({:remove_listener, name}, callbacks) when is_atom(name) do
    {:ok, :ok, Map.delete(callbacks, name)}
  end
end
