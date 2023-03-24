defmodule MediaWishlistWeb.SearchController do
  use MediaWishlistWeb, :controller
  import EbayApi

  def start(conn, _params) do
    render(conn, :start)
  end

  def results(conn, %{"search" => %{"search_term" => search_term}}) do
    search_results = ebay_api_fetch(search_term)
    render(conn, :results, search_results: search_results)
  end

  def ebay_api_fetch(search_term) when search_term == "" do
    nil
  end

  def ebay_api_fetch(search_term) when search_term != "" do
    url =
      "https://api.ebay.com/buy/browse/v1/item_summary/search?q=#{search_term}&category_ids=261186&limit=10"

    # token = Application.fetch_env!(:media_wishlist, :ebay_api_token)
    client = EbayApi.new()
    client = EbayApi.get_token(client, [], [])
    case OAuth2.Client.get(client, url) do
      {:ok, %OAuth2.Response{status_code: 200, body: body}} ->
        body

      {:ok, %OAuth2.Response{status_code: 404}} ->
        "404 Error"

      {:error, %OAuth2.Error{reason: reason}} ->
        IO.inspect(reason)
    end
  end
end
