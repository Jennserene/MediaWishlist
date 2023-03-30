defmodule MediaWishlistWeb.PageController do
  use MediaWishlistWeb, :controller

  def home(conn, _params) do
    case conn.assigns[:current_user] do
      nil ->
        redirect(conn, to: ~p"/users/log_in", conn: conn)

      _ ->
        redirect(conn, to: ~p"/wishlist")
    end
  end
end
