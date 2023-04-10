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

defmodule SingleGameDeal do
  @derive [Poison.Encoder]
  defstruct [
    :storeID,
    :dealID,
    :price,
    :retailPrice,
    :savings
  ]
end

defmodule SingleGameDeals do
  @derive [Poison.Encoder]
  defstruct [
    :info,
    :cheapestPriceEver,
    deals: [%SingleGameDeal{}]
  ]
end

defmodule Store do
  @derive [Poison.Encoder]
  defstruct [
    :storeID,
    :storeName,
    :isActive,
    :images
  ]
end
