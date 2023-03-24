defmodule Deal do
  @derive [Poison.Encoder]
  defstruct [
    :gameID,
    :steamAppID,
    :cheapest,
    :cheapestDealID,
    :external,
    :thumb
  ]
end
