defmodule TerminalUI.Supervisor do
  use Supervisor

  def start_link(opts \\ []) do
    Supervisor.start_link(__MODULE__, :ok, opts)
  end

  def stop do
    case Process.whereis(TerminalUI.Supervisor) do
      pid when is_pid(pid) ->
        Process.exit(TerminalUI.Supervisor, :shutdown)
      _ ->
        :ok
    end
  end

  def init(:ok) do
    children = [
      screen,
      ticker
    ]

    opts = [strategy: :one_for_one, name: TerminalUI.Supervisor]

    supervise(children, opts)
  end

  defp screen do
    worker(TerminalUI.Screen, [
      %{:pid => Application.get_env(:terminal_ui, :screen_pid)}
    ])
  end

  defp ticker do
    worker(Task, [
      TerminalUI.Ticker,
      :tick,
      [
        %{
          :screen_pid => Application.get_env(:terminal_ui, :screen_pid),
          :fps        => Application.get_env(:terminal_ui, :fps)
        }
      ]
    ])
  end
end
