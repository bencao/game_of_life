defmodule WebUI.Sync do
  use GenServer

  def start_link(opts \\ []) do
    GenServer.start_link(__MODULE__, opts, [name: opts[:pid]])
  end

  def refresh(server, size, cells) do
    GenServer.cast(server, {:refresh, size, cells})
  end

  def init(opts) do
    Engine.API.add_listener(:web_ui, fn size, cells ->
      refresh(opts[:pid], size, cells)
    end)

    {:ok, nil}
  end

  def terminate(_reason, _state) do
    Engine.API.remove_listener(:web_ui)
  end

  def handle_cast({:refresh, size, cells}, state) do
    WebUI.Endpoint.broadcast!("game:game_of_life", "render", %{size: size, cells: cells})

    {:noreply, state}
  end
end
