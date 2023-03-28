defmodule MediaWishlistWeb.WishlistController do
  use MediaWishlistWeb, :controller
  require Logger

  alias MediaWishlist.Favorites

  def new(conn, %{"game" => %{"dealID" => dealID}}) do
    result = CheapSharkApi.deal_lookup(dealID)
    result = Map.put(result, :user_id, conn.assigns.current_user.id)

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

  def update_local_favorite(favorite, best) when favorite.dealID != best.dealID do
    new_favorite = favorite
    |> Map.put(:storeID, best.storeID)
    |> Map.put(:dealID, best.dealID)
    |> Map.put(:currPrice, best.price)
    |> Map.put(:retailPrice, best.retailPrice)
    |> Map.put(:onSale, Float.parse(best.price) < Float.parse(best.retailPrice))
    {:changed, new_favorite}
  end

  def update_local_favorite(favorite, best) when favorite.dealID == best.dealID do
    {:same, favorite}
  end

  def update_db_wrapper(conn, orig_fav, new_fav) do
    case Favorites.update_favorite(orig_fav, new_fav) do
      {:ok, favorite} ->
        Logger.info(
          "Updated #{favorite.title} in #{conn.assigns.current_user.email} with latest deal Successfully."
        )

      {:error, %Ecto.Changeset{} = changeset} ->
        Logger.error("Something went wrong updating a favorite with a new deal!")
        Logger.error(IO.inspect(changeset))
    end
  end

  def game(conn, %{"id" => id}) do
    orig_favorite = Favorites.get_favorite!(id)
    result = CheapSharkApi.game_deals_lookup(orig_favorite.gameID)
    [best | rest] = result.deals

    favorite =
      case update_local_favorite(orig_favorite, best) do
        {:changed, new_favorite} ->
          update_db_wrapper(conn, orig_favorite, new_favorite)
          new_favorite

        {:same, same_favorite} ->
          same_favorite
      end

    render(conn, :game, favorite: favorite, rest: rest)
  end
end
