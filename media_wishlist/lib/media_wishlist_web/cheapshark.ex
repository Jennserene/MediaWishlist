defmodule CheapSharkApi do
  require Logger

  @list_of_deals [%Deal{}]

  def search_deals(search_term) do
    "https://www.cheapshark.com/api/1.0/games?title=#{search_term}"
    |> fetch_data()
    |> Poison.decode!(%{as: @list_of_deals})
  end

  def deal_lookup(dealID) do
    "https://www.cheapshark.com/api/1.0/deals?id=#{dealID}"
    |> fetch_data()
    |> Poison.decode!(as: %SingleDeal{})
    |> convert_to_favorite(dealID)
  end

  def fetch_data(url) do
    case HTTPoison.get(url) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        body
      {:ok, %HTTPoison.Response{status_code: 404}} ->
        "404 error"
      {:error, %HTTPoison.Error{reason: reason}} ->
        Logger.error(IO.inspect reason)
    end
  end

  def convert_to_favorite(deal, dealID) do
    {curr_price, _} = Float.parse(deal.gameInfo.salePrice)
    {retail_price, _} = Float.parse(deal.gameInfo.retailPrice)
    %{
      currPrice: deal.gameInfo.salePrice,
      retailPrice: deal.gameInfo.retailPrice,
      dealID: dealID,
      gameID: deal.gameInfo.gameID,
      metacriticLink: deal.gameInfo.metacriticLink,
      onSale: curr_price < retail_price,
      steamAppID: deal.gameInfo.steamAppID,
      storeID: deal.gameInfo.storeID,
      thumb: deal.gameInfo.thumb,
      title: deal.gameInfo.name
    }
  end
end
