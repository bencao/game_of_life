defmodule Patterns do
  defmacro __using__(opts \\ %{}) do
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
