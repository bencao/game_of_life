defmodule TerminalUI.Canvas do
  @padding %{:top => 3, :right => 0, :buttom => 1, :left => 6}

  @doc """
  Init a canvas
  """
  def init do
    :encurses.initscr
    :encurses.noecho

    :ok
  end

  @doc """
  Draw cells on the canvas
  """
  def draw(size, cells) do
    :encurses.erase

    draw_title(size)

    draw_boundary(size)

    cells
      |> with_x_y(size)
      |> Enum.each &(draw_cell &1)

    draw_footer(size)

    :encurses.refresh

    :ok
  end

  defp draw_title(size) do
    :encurses.mvaddstr(@padding.left + size * 2 + 3, @padding.top + 1, 'Game')
    :encurses.mvaddstr(@padding.left + size * 2 + 5, @padding.top + 2, 'of')
    :encurses.mvaddstr(@padding.left + size * 2 + 7, @padding.top + 3, 'Life')
  end

  defp draw_boundary(size) do
    # draw top line
    :encurses.mvaddstr(@padding.left, @padding.top, '+')
    :encurses.mvaddstr(@padding.left + 1, @padding.top, Stream.cycle([?-]) |> Enum.take(size * 2))
    :encurses.mvaddstr(@padding.left + size * 2 + 1, @padding.top, '+')

    # draw left line
    1..size
      |> Enum.each &(:encurses.mvaddstr(@padding.left, @padding.top + &1, '|'))

    # draw right line
    1..size
      |> Enum.each &(:encurses.mvaddstr(@padding.left + size * 2 + 1, @padding.top + &1, '|'))

    # draw bottom line
    :encurses.mvaddstr(@padding.left, @padding.top + size + 1, '+')
    :encurses.mvaddstr(@padding.left + 1, @padding.top + size + 1, Stream.cycle([?-]) |> Enum.take(size * 2))
    :encurses.mvaddstr(@padding.left + size * 2 + 1, @padding.top + size + 1, '+')
  end

  defp draw_cell({x, y, val}) do
    :encurses.mvaddstr(@padding.left + 1 + 2 * x, @padding.top + 1 + y, val)
  end

  defp draw_footer(size) do
    :encurses.mvaddstr(@padding.left + size * 2 + 3, @padding.top + 8, 'Built')
    :encurses.mvaddstr(@padding.left + size * 2 + 5, @padding.top + 9, 'With')
    :encurses.mvaddstr(@padding.left + size * 2 + 7, @padding.top + 10, 'Elixir')
  end

  defp with_x_y(list, row_size) do
    index_to_x_y = fn {val, index} ->
      {rem(index, row_size), div(index, row_size), display(val)}
    end

    Enum.with_index(list)
      |> Enum.map &(index_to_x_y.(&1))
  end

  defp display(0), do: ' '
  defp display(1), do: 'O'
end

