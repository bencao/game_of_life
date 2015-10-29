defmodule Engine.Evolution do
  alias Engine.World, as: World

  @doc """
  Produce a new world, start from `world`, and call `callback` with the new world as the first parameter
  """
  def produce(world, callback) do
    {:ok, new_world} =
      world
        |> World.cells_with_x_y
        |> Enum.map(&(with_ajacents &1, world))
        |> Enum.map(&(new_state &1))
        |> World.new

    callback.(new_world)
  end

  @doc """
  Calculate the new state for cell

     iex> Engine.Evolution.new_state({0, [1, 1, 0]})
     0
     iex> Engine.Evolution.new_state({0, [1, 1, 1, 0, 0]})
     1

  """
  def new_state({cell, adjacents}) do
    adjacents
      |> Enum.filter(&(World.alive_cell? &1))
      |> Enum.count
      |> rule(cell)
  end

  @doc """
  Any live cell with fewer than two live neighbours dies, as if caused by under-population.

      iex> Engine.Evolution.rule(0, 1)
      0
      iex> Engine.Evolution.rule(1, 1)
      0

  Any live cell with two or three live neighbours lives on to the next generation.

      iex> Engine.Evolution.rule(2, 1)
      1
      iex> Engine.Evolution.rule(3, 1)
      1

  Any live cell with more than three live neighbours dies, as if by over-population.

      iex> Engine.Evolution.rule(4, 1)
      0
      iex> Engine.Evolution.rule(5, 1)
      0
      iex> Engine.Evolution.rule(6, 1)
      0
      iex> Engine.Evolution.rule(7, 1)
      0
      iex> Engine.Evolution.rule(8, 1)
      0

  Any dead cell with exactly three live neighbours becomes a live cell, as if by reproduction.

      iex> Engine.Evolution.rule(0, 0)
      0
      iex> Engine.Evolution.rule(1, 0)
      0
      iex> Engine.Evolution.rule(2, 0)
      0
      iex> Engine.Evolution.rule(3, 0)
      1
      iex> Engine.Evolution.rule(4, 0)
      0
      iex> Engine.Evolution.rule(5, 0)
      0
      iex> Engine.Evolution.rule(6, 0)
      0
      iex> Engine.Evolution.rule(7, 0)
      0
      iex> Engine.Evolution.rule(8, 0)
      0

  """
  def rule(2, 1), do: 1
  def rule(3, 1), do: 1
  def rule(3, 0), do: 1
  def rule(_, _), do: 0

  defp with_ajacents({x, y, cell}, world) do
    {cell, World.adjacent_cells_at({x, y}, world)}
  end
end
