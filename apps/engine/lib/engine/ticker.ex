defmodule Engine.Ticker do
  @moduledoc """
  Trigger judgement in fixed time interval
  """

  @doc """
  Tick judge every `interval` ms
  """
  def tick(judge_pid, interval) do
    Engine.Judge.tick(judge_pid)

    :timer.sleep(interval)

    tick(judge_pid, interval)
  end
end
