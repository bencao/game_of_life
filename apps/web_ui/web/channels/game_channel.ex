defmodule WebUI.GameChannel do
  use Phoenix.Channel

  def join("game:game_of_life", _message, socket) do
    {:ok, socket}
  end

  def handle_in("refresh", _, socket) do
    {:ok, size, cells} = Engine.API.inspect

    broadcast! socket, "render", %{size: size, cells: cells}
    {:noreply, socket}
  end
end
