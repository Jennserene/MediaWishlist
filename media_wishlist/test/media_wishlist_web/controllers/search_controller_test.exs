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

    test "displays single game information", %{conn: conn} do
      conn = sign_up(conn)

      with_mock HTTPoison,
        get: fn _url ->
          {:ok, %HTTPoison.Response{status_code: 200, body: game_deals_lookup_fetch_result()}}
        end do
        conn = get(conn, ~p"/search/1234")
        assert html_response(conn, 200) =~ "LEGO Batman"
        assert html_response(conn, 200) =~ "Add to Wishlist"
        assert html_response(conn, 200) =~ "This game is on sale!"
        assert html_response(conn, 200) =~ "Get the latest deal for 16.05"
        assert html_response(conn, 200) =~ "Available"
        assert html_response(conn, 200) =~ "at Fanatical"
        assert html_response(conn, 200) =~ "Normal retail price: 19.99"

        assert html_response(conn, 200) =~
                 "Don't want to buy from Fanatical? Here are other options:"

        assert html_response(conn, 200) =~ "GameBillet"
        assert html_response(conn, 200) =~ "16.79"
      end
    end

    test "does not display games that do not exist", %{conn: conn} do
      conn = sign_up(conn)

      with_mock HTTPoison,
        get: fn _url ->
          {:ok, %HTTPoison.Response{status_code: 200, body: ~S({"deals":[]})}}
        end do
        conn = get(conn, ~p"/search/0")
        assert redirected_to(conn) == ~p"/wishlist"
        assert Phoenix.Flash.get(conn.assigns.flash, :error) =~ "That is not a valid game ID"
      end
    end
  end
end
