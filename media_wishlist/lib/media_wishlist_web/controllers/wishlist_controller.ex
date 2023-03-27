defmodule MediaWishlistWeb.WishlistController do
  use MediaWishlistWeb, :controller
  require Logger

  alias MediaWishlist.Favorites

  def new(conn, %{"game" => %{"dealID" => dealID}}) do
    result = CheapSharkApi.deal_lookup(dealID)
    result = Map.put(result, :user_id, conn.assigns.current_user.id)
    case Favorites.create_favorite(result) do
      {:ok, favorite} ->
        Logger.info("Added favorite #{favorite.title} to #{conn.assigns.current_user.email}")
        redirect(conn, to: "/wishlist")
      {:error, %Ecto.Changeset{} = errchangeset} ->
        Logger.error("Something went wrong creating a favorite:")
        Logger.error(IO.inspect(errchangeset))
    end
  end

  def view(conn, _params) do
    render(conn, :view)
  end
end
