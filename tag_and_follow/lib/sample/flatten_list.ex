defmodule FlattenList do
  def flatten([]), do: []
  def flatten([head | tail]), do: flatten(head) ++ flatten(tail)
  def flatten(head), do: [head]

  def sum([]), do: 0
  def sum([head | tail]), do: sum(head) + sum(tail)
  def sum(num), do: num
end
