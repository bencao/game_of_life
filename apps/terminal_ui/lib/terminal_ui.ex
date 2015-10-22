defmodule TerminalUI do
  def start do
    TerminalUI.Supervisor.start_link
    hold
  end

  def stop do
    TerminalUI.Supervisor.stop
  end

  def hold do
    :timer.sleep(10000)
    hold
  end
end
