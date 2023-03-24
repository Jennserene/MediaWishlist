defmodule MediaWishlistWeb.SearchController do
  use MediaWishlistWeb, :controller

  def start(conn, _params) do
    render(conn, :start)
  end

  def results(conn, %{"search" => %{"search_term" => search_term}}) do
    render(conn, :results, search_results: search_term)
  end
end
