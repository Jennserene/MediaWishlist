defmodule MediaWishlistWeb.WishlistController do
  use MediaWishlistWeb, :controller
  require Logger

  alias MediaWishlist.Favorites

  def new(conn, %{"game" => %{"dealID" => dealID}}) do
    result = CheapSharkApi.deal_lookup(dealID)
    result = Map.put(result, :user_id, conn.assigns.current_user.id)
    case Favorites.create_favorite(result) do
      {:ok, favorite} ->
        log_string = "Added favorite #{favorite.title} to #{conn.assigns.current_user.email}'s wishlist"
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

    log_string = "Favorite #{favorite.title} deleted successfully from #{conn.assigns.current_user.email}'s wishlist."
    Logger.info(log_string)
    conn
    |> put_flash(:info, log_string)
    |> redirect(to: ~p"/wishlist")
  end
end
