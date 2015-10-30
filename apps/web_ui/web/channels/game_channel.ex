defmodule WebUI.GameChannel do
  use Phoenix.Channel

  def join("game:game_of_life", _message, socket) do
    {:ok, socket}
  end

  def handle_in("load", %{"pattern" => pattern}, socket) do
    String.to_existing_atom("Elixir." <> pattern).load

    {:noreply, socket}
  end
end
