defmodule Patterns.Oscillators.Beacon do
  use Patterns.Loadable

  @behaviour Patterns.Loadable

  def to_list do
    [
      0, 0, 0, 0, 0, 0,
      0, 1, 1, 0, 0, 0,
      0, 1, 1, 0, 0, 0,
      0, 0, 0, 1, 1, 0,
      0, 0, 0, 1, 1, 0,
      0, 0, 0, 0, 0, 0
    ]
  end
end
