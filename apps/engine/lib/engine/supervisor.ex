defmodule Engine.Supervisor do
  use Supervisor

  def start_link(opts \\ []) do
    Supervisor.start_link(__MODULE__, :ok, opts)
  end

  def init(:ok) do
    children = [
      evolution,
      event,
      judge,
      ticker
    ]

    opts = [strategy: :one_for_one, name: Engine.Supervisor]

    supervise(children, opts)
  end

  defp judge do
    worker(Engine.Judge, [
      %{
        pid:               Application.get_env(:engine, :judge_pid),
        max_ignore_ticks:  Application.get_env(:engine, :judge_max_ignore_ticks),
        evolution_sup_pid: Application.get_env(:engine, :evolution_sup_pid),
        event_manager_pid: Application.get_env(:engine, :event_manager_pid)
      }
    ])
  end

  defp ticker do
    worker(Task, [
      Engine.Ticker,
      :tick,
      [
        Application.get_env(:engine, :judge_pid),
        Application.get_env(:engine, :ticker_interval)
      ]
    ])
  end

  def evolution do
    supervisor(Task.Supervisor, [
      [name: Application.get_env(:engine, :evolution_sup_pid)]
    ])
  end

  def event do
    worker(GenEvent, [
      [name: Application.get_env(:engine, :event_manager_pid)]
    ])
  end
end
