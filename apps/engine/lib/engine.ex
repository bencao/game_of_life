defmodule Engine do
  use Application

  def start(_type, _args) do
    Engine.Supervisor.start_link
  end
end
