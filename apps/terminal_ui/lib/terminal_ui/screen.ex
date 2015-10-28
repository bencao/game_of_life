defmodule TerminalUI.Screen do
  use GenServer

  @doc """
  """
  def start_link(settings) do
    GenServer.start_link(__MODULE__, settings, [name: settings.pid])
  end

  @doc """
  Refresh the canvas with new `size` and `cells`
  """
  def refresh(server, size, cells) do
    GenServer.cast(server, {:refresh, size, cells})
  end

  def init(settings) do
    TerminalUI.Canvas.init

    Engine.API.add_listener(:terminal_ui, fn size, cells ->
      refresh(settings.pid, size, cells)
    end)

    {:ok, []}
  end

  def terminate(_reason, _state) do
    Engine.API.remove_listener(:terminal_ui)
  end

  def handle_cast({:refresh, size, cells}, state) do
    TerminalUI.Canvas.draw(size, cells)

    {:noreply, state}
  end
end

