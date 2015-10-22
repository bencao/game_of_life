defmodule TerminalUI.Screen do
  use GenServer

  @doc """
  """
  def start_link(settings) do
    GenServer.start_link(__MODULE__, :ok, [name: settings.pid])
  end

  @doc """
  Refresh the canvas
  """
  def refresh(server) do
    GenServer.cast(server, {:refresh})
  end

  def init(:ok) do
    TerminalUI.Canvas.init

    {:ok, []}
  end

  def handle_cast({:refresh}, state) do
    {:ok, size, cells} = Engine.API.inspect

    TerminalUI.Canvas.draw(size, cells)

    {:noreply, state}
  end
end

