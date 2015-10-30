defmodule Patterns.Collector do
  @moduledoc """
  Collect patterns from source files, so when we have new patterns added it will be detected automatically during compile time
  """

  @doc """
  Collect pattern from `files`
  """
  def collect_file(file) do
    File.stream!(file, [], :line)
      |> Enum.take(1)
      |> List.first
      |> String.strip
      |> String.split
      |> Enum.at(1)
  end

  @doc """
  Collect pattern from `directory`
  """
  def collect_directory(directory) do
    IO.puts "collecting #{directory}"

    {:ok, sub_directory_files} = File.ls(directory)

    Enum.map(sub_directory_files, fn file ->
      full_name = Path.join(directory, file)

      if File.dir?(full_name) do
        collect_directory(full_name)
      else
        collect_file(full_name)
      end
    end) |> List.flatten
  end

  @doc false
  defmacro __using__(_) do
    quote do
      @before_compile Patterns.Collector
    end
  end

  @doc false
  defmacro __before_compile__(env) do
    patterns =
      ["gun", "oscillators", "spaceships", "still_lifes"]
        |> Enum.map(&(Path.join __DIR__, &1))
        |> Enum.map(&(collect_directory &1))
        |> List.flatten

    quote do
      def all do
        unquote(patterns)
      end
    end
  end
end
