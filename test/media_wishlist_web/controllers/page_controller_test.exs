defmodule MediaWishlistWeb.PageControllerTest do
  use MediaWishlistWeb.ConnCase
  import MediaWishlist.AccountsFixtures

  test "GET / logged out", %{conn: conn} do
    conn = get(conn, ~p"/")

    assert redirected_to(conn) == ~p"/users/log_in"
  end

  test "GET / logged in", %{conn: conn} do
    conn = sign_up(conn)
    conn = get(conn, ~p"/")

    assert redirected_to(conn) == ~p"/wishlist"
  end
end
