defmodule Engine.World do
  @moduledoc """
  A world is a 2D space composite by either alive of dead cells.
  We will treat the matrix direction as it is typical described on Math books: X axis on the bottom and Y axis on the left.

  Y axis
   ^
   |* (1, 4)
   | * (2, 3)
   |
   |   * (4, 1)
   ---------------> X axis
  """

  @status_alive 1
  @status_dead  0

  @doc """
  Initialize a void world

      iex> {:ok, world} = Engine.World.new
      iex> Engine.World.size(world)
      0
      iex> Engine.World.cell_at({0, 0}, world)
      nil

  """
  def new do
    {:ok, [ size: 0, canvas: nil ]}
  end

  @doc """
  Initialize a world with `size` and `matrix`

      iex> {:ok, world} = Engine.World.new([
      ...>   0, 1, 0,
      ...>   1, 0, 1,
      ...>   0, 0, 1
      ...> ])
      iex> Engine.World.size(world)
      3
      iex> Engine.World.cell_at({2, 0}, world)
      1

  """
  def new(matrix) do
    size = matrix |> length |> :math.sqrt |> trunc

    if length(matrix) == size * size do
      canvas = :array.from_list(matrix, @status_dead)
      {:ok, [ size: size, canvas: canvas ]}
    else
      {:error, :not_a_square_matrix}
    end
  end

  @doc """
  Get the size of a `world`

      iex> {:ok, world} = Engine.World.new
      iex> Engine.World.size(world)
      0
      iex> {:ok, world} = Engine.World.new([1])
      iex> Engine.World.size(world)
      1

  """
  def size(world) do
    world[:size]
  end

  @doc """
  Judge whether a cell is alive

      iex> Engine.World.alive_cell?(1)
      true
      iex> Engine.World.alive_cell?(0)
      false

  """
  def alive_cell?(@status_alive), do: true
  def alive_cell?(_), do: false

  @doc """
  Get the cell status on position (`x`, `y`)

      iex> {:ok, world} = Engine.World.new
      iex> Engine.World.cell_at({0, 0}, world)
      nil
      iex> Engine.World.cell_at({1, 1}, world)
      nil
      iex> Engine.World.cell_at({-1, 0}, world)
      nil
      iex> Engine.World.cell_at({1, -1}, world)
      nil

      iex> {:ok, world} = Engine.World.new([
      ...>   0, 1, 0,
      ...>   1, 0, 1,
      ...>   0, 0, 1
      ...> ])
      iex> Engine.World.cell_at({0, 0}, world)
      0
      iex> Engine.World.cell_at({1, 0}, world)
      0
      iex> Engine.World.cell_at({2, 0}, world)
      1
      iex> Engine.World.cell_at({0, 1}, world)
      1
      iex> Engine.World.cell_at({1, 1}, world)
      0
      iex> Engine.World.cell_at({2, 1}, world)
      1
      iex> Engine.World.cell_at({0, 2}, world)
      0
      iex> Engine.World.cell_at({1, 2}, world)
      1
      iex> Engine.World.cell_at({2, 2}, world)
      0
      iex> Engine.World.cell_at({3, 1}, world)
      nil
      iex> Engine.World.cell_at({1, 3}, world)
      nil
  """
  def cell_at({x, _}, _) when x < 0, do: nil
  def cell_at({_, y}, _) when y < 0, do: nil

  def cell_at({x, y}, world) do
    case world[:size] do
      s when x >= s -> nil
      s when y >= s -> nil
      _ ->
        (index(world[:size], x, y) |> :array.get(world[:canvas]))
    end
  end

  @doc """
  Get adjacent cells around position (`x`, `y`)
  Starts from left top adjacent cell and continue in left to right, top to bottom order

      iex> {:ok, world} = Engine.World.new
      iex> Engine.World.adjacent_cells_at({0, 0}, world)
      []

      iex> {:ok, world} = Engine.World.new([
      ...>   0, 1, 0,
      ...>   1, 0, 1,
      ...>   0, 0, 1
      ...> ])
      iex> Engine.World.adjacent_cells_at({0, 0}, world)
      [1, 0, 0]
      iex> Engine.World.adjacent_cells_at({1, 0}, world)
      [1, 0, 1, 0, 1]
      iex> Engine.World.adjacent_cells_at({2, 0}, world)
      [0, 1, 0]
      iex> Engine.World.adjacent_cells_at({0, 1}, world)
      [0, 1, 0, 0, 0]
      iex> Engine.World.adjacent_cells_at({1, 1}, world)
      [0, 1, 0, 1, 1, 0, 0, 1]
      iex> Engine.World.adjacent_cells_at({2, 1}, world)
      [1, 0, 0, 0, 1]
      iex> Engine.World.adjacent_cells_at({0, 2}, world)
      [1, 1, 0]
      iex> Engine.World.adjacent_cells_at({1, 2}, world)
      [0, 0, 1, 0, 1]
      iex> Engine.World.adjacent_cells_at({2, 2}, world)
      [1, 0, 1]

  """
  def adjacent_cells_at({x, y}, world) do
    [
      {x - 1, y + 1}, {x, y + 1}, {x + 1, y + 1},
      {x - 1, y},                 {x + 1, y},
      {x - 1, y - 1}, {x, y - 1}, {x + 1, y - 1}
    ]
      |> Enum.filter(&position_valid?(&1, world))
      |> Enum.map(&cell_at(&1, world))
  end

  @doc """
  Get a list of all cells in the world in a manner of a 3 dimmension tuple {x, y, cell},
  following the order from top left, flow to bottom right, right first then down.

      iex> {:ok, world} = Engine.World.new([
      ...>   0, 1, 0,
      ...>   1, 0, 1,
      ...>   0, 0, 1
      ...> ])
      iex> Engine.World.cells(world)
      [
        {0, 2, 0}, {1, 2, 1}, {2, 2, 0},
        {0, 1, 1}, {1, 1, 0}, {2, 1, 1},
        {0, 0, 0}, {1, 0, 0}, {2, 0, 1}
      ]
  """
  def cells(world) do
    boundary = size(world) - 1

    unless boundary < 0 do
      Enum.map(boundary..0, fn y ->
        Enum.map(0..boundary, fn x ->
          {x, y, cell_at({x, y}, world)}
        end)
      end) |> Enum.reduce([], &Enum.into/2)
    else
      []
    end
  end

  defp index(size, x, y) do
    size * (size - 1 - y) + x
  end

  defp position_valid?({x, y}, world) do
    boundary = size(world) - 1

    x >= 0 && x <= boundary && y >= 0 && y <= boundary
  end
end
