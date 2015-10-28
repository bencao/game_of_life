defmodule Patterns.StillLifes.Block do
  use Patterns.Loadable

  def to_list do
    [
      0, 0, 0, 0,
      0, 1, 1, 0,
      0, 1, 1, 0,
      0, 0, 0, 0
    ]
  end
end
