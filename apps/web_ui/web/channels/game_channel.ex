defmodule WebUI.GameChannel do
  use Phoenix.Channel

  def join("game:game_of_life", _message, socket) do
    {:ok, socket}
  end
end
