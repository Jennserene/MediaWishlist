defmodule MediaWishlistWeb.SearchControllerTest do
  use MediaWishlistWeb.ConnCase
  use ExUnit.Case
  import Mock
  import MediaWishlist.AccountsFixtures
  import MediaWishlist.CheapSharkFixtures

  describe "search" do
    test "redirect to wishlist with get request", %{conn: conn} do
      conn = sign_up(conn)
      conn = get(conn, ~p"/search")

      assert redirected_to(conn) == ~p"/wishlist"
    end

    test "displays the search results screen with post request", %{conn: conn} do
      conn = sign_up(conn)

      with_mock HTTPoison,
        get: fn _url ->
          {:ok, %HTTPoison.Response{status_code: 200, body: search_deals_fetch_result()}}
        end do
        conn = post(conn, ~p"/search", %{"search" => %{"search_term" => "Batman"}})
        assert html_response(conn, 200) =~ "LEGO Batman"
        assert html_response(conn, 200) =~ "16.05"
        assert html_response(conn, 200) =~ "Add"
        assert html_response(conn, 200) =~ "Buy"
      end
    end
  end
end
