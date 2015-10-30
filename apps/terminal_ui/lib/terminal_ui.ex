defmodule TerminalUI do
  def start do
    sup_pid = TerminalUI.Supervisor.start_link

    receive do
      :stop ->
        Process.exit(sup_pid, :shutdown)
        :ok
    end
  end

  def stop(pid) do
    send pid, :stop
  end
end
