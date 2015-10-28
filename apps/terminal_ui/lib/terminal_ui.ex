defmodule TerminalUI do
  use Application

  def start(_type, _args) do
    TerminalUI.Supervisor.start_link
  end
end
