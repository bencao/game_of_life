defmodule Patterns.StillLifes.Loaf do
  use Patterns.Loadable

  @behaviour Patterns.Loadable

  def to_list do
    [
      0, 0, 0, 0, 0, 0,
      0, 0, 1, 1, 0, 0,
      0, 1, 0, 0, 1, 0,
      0, 0, 1, 0, 1, 0,
      0, 0, 0, 1, 0, 0,
      0, 0, 0, 0, 0, 0
    ]
  end
end
