defmodule CheapSharkApi do
  require Logger
  alias MediaWishlist.Favorites

  @list_of_deals [%Deal{}]
  @list_of_stores [%Store{}]
  @list_of_games [%SingleGameDeals{}]

  def search_deals(search_term) do
    search_term
    |> URI.encode()
    |> (&"https://www.cheapshark.com/api/1.0/games?title=#{&1}").()
    |> fetch_data()
    |> Poison.decode!(%{as: @list_of_deals})
  end

  def deal_lookup(dealID) do
    "https://www.cheapshark.com/api/1.0/deals?id=#{dealID}"
    |> fetch_data()
    |> Poison.decode!(as: %SingleDeal{})
    |> convert_to_favorite(dealID)
  end

  def game_deals_lookup(gameID) do
    "https://www.cheapshark.com/api/1.0/games?id=#{gameID}"
    |> fetch_data()
    |> Poison.decode!(as: %SingleGameDeals{})
    |> convert_to_include_store_names()
  end

  def fetch_data(url) do
    case HTTPoison.get(url) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        body

      {:ok, %HTTPoison.Response{status_code: 404}} ->
        "404 error"

      {:error, %HTTPoison.Error{reason: reason}} ->
        Logger.error(IO.inspect(reason))
    end
  end

  def store_name(store) do
    store.storeName
  end

  def retrieve_store(storeID) do
    File.read!(Path.join(:code.priv_dir(:media_wishlist), "data/stores.json"))
    |> Poison.decode!(%{as: @list_of_stores})
    |> Enum.find(fn store -> store.storeID == storeID end)
  end

  def retrieve_store_wrapper(storeID) do
    case retrieve_store(storeID) do
      nil ->
        store_data = fetch_data("https://www.cheapshark.com/api/1.0/stores")
        File.write!(Path.join(:code.priv_dir(:media_wishlist), "data/stores.json"), store_data)

        retrieve_store(storeID)
        |> store_name()

      store ->
        store_name(store)
    end
  end

  def convert_to_include_store_names(game) do
    deals_with_store_names =
      game.deals
      |> Enum.map(fn deal -> Map.put(deal, :storeID, retrieve_store_wrapper(deal.storeID)) end)

    Map.put(game, :deals, deals_with_store_names)
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
      storeID: retrieve_store_wrapper(deal.gameInfo.storeID),
      thumb: deal.gameInfo.thumb,
      title: deal.gameInfo.name
    }
  end

  def merge_into_favorite(game, new_deals, email) do
    deal = new_deals[game.gameID]
    [best | rest] = deal["deals"]
    fixed_best = for {key, val} <- best, into: %{}, do: {String.to_atom(key), val}
    fixed_best = Map.put(fixed_best, :storeID, retrieve_store_wrapper(fixed_best.storeID))
    Favorites.update_local_favorite_wrapper(email, game, fixed_best)
  end

  def fetch_users_latest_prices(favs, email) do
    favs
    |> Enum.map(fn fav -> fav.gameID end)
    |> Enum.join(",")
    |> (&"https://www.cheapshark.com/api/1.0/games?ids=#{&1}").()
    |> fetch_data()
    |> Poison.decode!()
    |> (fn new_deals ->
          Enum.map(favs, fn fav -> merge_into_favorite(fav, new_deals, email) end)
        end).()
  end
end
