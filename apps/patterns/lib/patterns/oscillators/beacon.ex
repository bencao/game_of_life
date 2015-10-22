defmodule Patterns.Oscillators.Beacon do
  use Patterns

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
