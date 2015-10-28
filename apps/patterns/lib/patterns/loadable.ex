defmodule Patterns.Loadable do
  defmacro __using__(_) do
    quote do
      @doc """
      Load current pattern into engine
      """
      def load do
        Engine.API.load to_list
      end
    end
  end
end
