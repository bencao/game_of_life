defmodule TerminalUI.Ticker do
  @doc """
  Tick in a frequency of the `fps` requirement
  """
  def tick(settings = %{:screen_pid => screen_pid, :fps => fps}) do
    TerminalUI.Screen.refresh(screen_pid)

    div(1000, fps) |> :timer.sleep

    tick(settings)
  end
end
