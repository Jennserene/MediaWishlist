defmodule MediaWishlistWeb.WishlistController do
  use MediaWishlistWeb, :controller
  require Logger

  alias MediaWishlist.Favorites

  def new(conn, %{"game" => %{"dealID" => dealID}}) do
    result = CheapSharkApi.deal_lookup(dealID)
    result = Map.put(result, :user_id, conn.assigns.current_user.id)

    case check_for_duplicate_favorite(conn, result) do
      true ->
        conn
        |> put_flash(:error, "#{result.title} is already on your wishlist")
        |> redirect(to: "/wishlist")

      false ->
        new_create(conn, result)
    end
  end

  defp check_for_duplicate_favorite(conn, result) do
    Favorites.list_user_favorites(conn.assigns.current_user.id)
    |> Enum.any?(fn fav -> fav.gameID == result.gameID end)
  end

  defp new_create(conn, result) do
    case Favorites.create_favorite(result) do
      {:ok, favorite} ->
        log_string =
          "Added favorite #{favorite.title} to #{conn.assigns.current_user.email}'s wishlist"

        Logger.info(log_string)

        conn
        |> put_flash(:info, log_string)
        |> redirect(to: "/wishlist")

      {:error, %Ecto.Changeset{} = errchangeset} ->
        Logger.error("Something went wrong creating a favorite:")
        Logger.error(IO.inspect(errchangeset))
    end
  end

  def view(conn, _params) do
    favorites = Favorites.list_user_favorites(conn.assigns.current_user.id)
    render(conn, :view, favorites: favorites)
  end

  def delete(conn, %{"id" => id}) do
    favorite = Favorites.get_favorite!(id)
    {:ok, _favorite} = Favorites.delete_favorite(favorite)

    log_string =
      "Favorite #{favorite.title} deleted successfully from #{conn.assigns.current_user.email}'s wishlist."

    Logger.info(log_string)

    conn
    |> put_flash(:info, log_string)
    |> redirect(to: ~p"/wishlist")
  end

  def game(conn, %{"id" => id}) do
    try do
      orig_favorite = Favorites.get_favorite!(id)

      if orig_favorite.user_id == conn.assigns.current_user.id do
        result = CheapSharkApi.game_deals_lookup(orig_favorite.gameID)
        [best | rest] = result.deals

        favorite =
          Favorites.update_local_favorite_wrapper(
            conn.assigns.current_user.email,
            orig_favorite,
            best
          )

        render(conn, :game, favorite: favorite, rest: rest)
      else
        conn
        |> put_flash(:error, "That is not a valid ID")
        |> redirect(to: ~p"/wishlist")
      end
    rescue
      Ecto.NoResultsError ->
        conn
        |> put_flash(:error, "That is not a valid ID")
        |> redirect(to: ~p"/wishlist")
    end
  end

  def fetch(conn, _params) do
    log_string = "Fetching latest prices for #{conn.assigns.current_user.email}'s wishlist"
    Logger.info(log_string)

    try do
      CheapSharkApi.fetch_all_for_user(
        conn.assigns.current_user.id,
        conn.assigns.current_user.email
      )

      conn
      |> put_flash(:info, log_string)
      |> redirect(to: ~p"/wishlist")
    rescue
      err in RuntimeError ->
        error_string = "Something went wrong fetching prices for #{conn.assigns.current_user.email}"
        Logger.error(error_string)
        Logger.error(err.message)

        conn
        |> put_flash(:error, error_string)
        |> redirect(to: ~p"/wishlist")
    end
  end
end
