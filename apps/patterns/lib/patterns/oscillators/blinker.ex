defmodule Patterns.Oscillators.Blinker do
  use Patterns.Loadable

  def to_list do
    [
      0, 0, 0, 0, 0,
      0, 0, 1, 0, 0,
      0, 0, 1, 0, 0,
      0, 0, 1, 0, 0,
      0, 0, 0, 0, 0
    ]
  end
end
