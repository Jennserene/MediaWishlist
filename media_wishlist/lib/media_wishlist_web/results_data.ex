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

defmodule GameInfo do
  @derive [Poison.Encoder]
  defstruct [
    :storeID,
    :gameID,
    :name,
    :steamAppID,
    :salePrice,
    :retailPrice,
    :steamRatingText,
    :steamRatingPercent,
    :steamRatingCount,
    :metacriticScore,
    :metacriticLink,
    :releaseDate,
    :publisher,
    :steamworks,
    :thumb
  ]
end

defmodule SingleDeal do
  @derive [Poison.Encoder]
  defstruct [
    :cheaperStores,
    :cheapestPrice,
    gameInfo: %GameInfo{}
  ]
end
