defmodule MediaWishlistWeb.SearchController do
  use MediaWishlistWeb, :controller

  def start(conn, _params) do
    redirect(conn, to: ~p"/wishlist")
  end

  def results(conn, %{"search" => %{"search_term" => search_term}}) do
    try do
      result = CheapSharkApi.search_deals(search_term)
      render(conn, :results, search_results: result)
    rescue
      err in RuntimeError ->
        error_string = "Something went wrong getting search results"

        Logger.error(error_string)
        Logger.error(err.message)

        conn
        |> put_flash(:error, error_string)
        |> redirect(to: ~p"/wishlist")
    end
  end

  def game(conn, %{"gameID" => gameID}) do
    try do
      result = CheapSharkApi.game_deals_lookup(gameID)

      if result.deals == [] do
        conn
        |> put_flash(:error, "That is not a valid game ID")
        |> redirect(to: ~p"/wishlist")
      else
        [best_raw | rest] = result.deals

        best = %{
          thumb: result.info["thumb"],
          title: result.info["title"],
          dealID: best_raw.dealID,
          currPrice: best_raw.price,
          retailPrice: best_raw.retailPrice,
          storeID: best_raw.storeID,
          onSale: Float.parse(best_raw.price) < Float.parse(best_raw.retailPrice)
        }

        render(conn, :search_game, best: best, rest: rest)
      end
    rescue
      err in RuntimeError ->
        error_string = "Something went wrong getting deals for that game"

        Logger.error(error_string)
        Logger.error(err.message)

        conn
        |> put_flash(:error, error_string)
        |> redirect(to: ~p"/wishlist")
    end
  end
end
