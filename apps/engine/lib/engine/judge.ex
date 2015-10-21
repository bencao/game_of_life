defmodule Engine.Judge do
  @moduledoc """
  Hold the single source of truth of how this game is going

  Judge state can either be :idle or {:judging, counts}
  where counts is the number of times judge have ignored tick events
  if the number of ignored tick event is more than max_ignore_ticks, Judge will give up ongoing judging and go back to idle again
  """

  use GenServer

  # client API

  @doc """
  Start the judge
  """
  def start_link(settings) do
    GenServer.start_link(__MODULE__, settings, [name: settings.pid])
  end

  @doc """
  Give the server a tick call
  """
  def tick(server) do
    GenServer.call(server, {:tick})
  end

  @doc """
  Goto `new_world`
  """
  def goto(server, new_world, force \\ true) do
    GenServer.call(server, {:goto, new_world, force})
  end

  @doc """
  Inspect `world` status
  """
  def inspect(server) do
    GenServer.call(server, {:inspect})
  end

  # server callback

  def init(state) do
    {:ok, world} = Engine.World.new
    {:ok, Enum.into(%{:world => world, :flag => :idle}, state)}
  end

  def handle_call({:tick}, _from, state = %{:flag => flag, :max_ignore_ticks => max_ignore_ticks}) do
    case flag do
      :idle ->
        # start a evolution task to produce the new world
        Task.Supervisor.start_child(state.evolution_sup_pid, fn ->
          Engine.Evolution.produce(state.world, &goto(state.pid, &1))
        end)

        {:reply, :ok, Enum.into(%{:flag => {:judging, 0}}, state)}
      {:judging, ignored_count} when ignored_count > max_ignore_ticks ->
        {:reply, :ok, Enum.into(%{:flag => :idle}, state)}
      {:judging, ignored_count} ->
        {:reply, :ok, Enum.into(%{:flag => {:judging, ignored_count + 1}}, state)}
    end
  end

  def handle_call({:goto, new_world, true}, _from, state) do
    {:reply, :ok, Enum.into(%{world: new_world, flag: :idle}, state)}
  end

  def handle_call({:goto, new_world, false}, _from, state = %{:flag => flag}) do
    case flag do
      {:judging, _} ->
        {:reply, :ok, Enum.into(%{world: new_world, flag: :idle}, state)}
      _ ->
        {:reply, :error, state}
    end
  end

  def handle_call({:inspect}, _from, state = %{:world => world}) do
    cells = Engine.World.cells(world) |> Enum.map(fn {_, _, cell} -> cell end)

    {:reply, {:ok, cells}, state}
  end
end
