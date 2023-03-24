defmodule MediaWishlistWeb.SearchController do
  use MediaWishlistWeb, :controller

  def start(conn, _params) do
    render(conn, :start)
  end

  def results(conn, %{"search" => %{"search_term" => search_term}}) do
    result = CheapSharkApi.search_deals(search_term)
    render(conn, :results, search_results: result)
  end
end
