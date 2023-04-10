defmodule MediaWishlistWeb.WishlistControllerTest do
  use MediaWishlistWeb.ConnCase
  use ExUnit.Case
  import Mock
  import MediaWishlist.AccountsFixtures
  import MediaWishlist.CheapSharkFixtures
  alias MediaWishlist.Favorites

  describe "wishlist" do
    test "create a new favorite", %{conn: conn} do
      conn = sign_up(conn)

      with_mock HTTPoison,
        get: fn _url ->
          {:ok, %HTTPoison.Response{status_code: 200, body: deal_lookup_fetch_result()}}
        end do
        conn = post(conn, ~p"/wishlist/new", %{"game" => %{"dealID" => "test_id"}})
        assert redirected_to(conn) == ~p"/wishlist"

        assert Phoenix.Flash.get(conn.assigns.flash, :info) =~
                 "Added favorite BioShock Infinite to"

        conn = get(conn, ~p"/wishlist")
        assert html_response(conn, 200) =~ "BioShock Infinite"
        assert html_response(conn, 200) =~ "Buy"
        assert html_response(conn, 200) =~ "Reviews"
        assert html_response(conn, 200) =~ "Delete"
        assert html_response(conn, 200) =~ "$59.99"
        assert html_response(conn, 200) =~ "$11.99"
      end
    end

    test "handles duplicate new favorite requests", %{conn: conn} do
      conn = sign_up(conn)

      with_mock HTTPoison,
        get: fn _url ->
          {:ok, %HTTPoison.Response{status_code: 200, body: deal_lookup_fetch_result()}}
        end do
        conn = post(conn, ~p"/wishlist/new", %{"game" => %{"dealID" => "test_id"}})

        assert Phoenix.Flash.get(conn.assigns.flash, :info) =~
                 "Added favorite BioShock Infinite to"

        conn = post(conn, ~p"/wishlist/new", %{"game" => %{"dealID" => "test_id"}})
        assert redirected_to(conn) == ~p"/wishlist"

        assert Phoenix.Flash.get(conn.assigns.flash, :error) =~
                 "BioShock Infinite is already on your wishlist"

        conn = get(conn, ~p"/wishlist")
        assert html_response(conn, 200) =~ "BioShock Infinite"
      end
    end

    test "does not display empty wishlist", %{conn: conn} do
      conn = sign_up(conn)

      conn = get(conn, ~p"/wishlist")
      assert html_response(conn, 200) =~ "Get started by searching for a game! ↗"
    end

    test "correctly deletes an added favorite", %{conn: conn} do
      conn = sign_up(conn)

      with_mock HTTPoison,
        get: fn _url ->
          {:ok, %HTTPoison.Response{status_code: 200, body: deal_lookup_fetch_result()}}
        end do
        conn = post(conn, ~p"/wishlist/new", %{"game" => %{"dealID" => "test_id"}})
        assert redirected_to(conn) == ~p"/wishlist"

        assert Phoenix.Flash.get(conn.assigns.flash, :info) =~
                 "Added favorite BioShock Infinite to"

        conn = get(conn, ~p"/wishlist")
        assert html_response(conn, 200) =~ "BioShock Infinite"

        [fav | _] = Favorites.list_user_favorites(conn.assigns.current_user.id)

        conn = delete(conn, ~p"/wishlist/#{fav.id}")
        assert redirected_to(conn) == ~p"/wishlist"

        assert Phoenix.Flash.get(conn.assigns.flash, :info) =~
                 "Favorite BioShock Infinite deleted successfully from"
      end
    end

    test "displays given game deal information", %{conn: conn} do
      conn = sign_up(conn)

      conn =
        with_mock HTTPoison,
          get: fn _url ->
            {:ok, %HTTPoison.Response{status_code: 200, body: deal_lookup_fetch_result()}}
          end do
          post(conn, ~p"/wishlist/new", %{"game" => %{"dealID" => "test_id"}})
        end

      [fav | _] = Favorites.list_user_favorites(conn.assigns.current_user.id)

      with_mock HTTPoison,
        get: fn _url ->
          {:ok,
           %HTTPoison.Response{
             status_code: 200,
             body: game_deals_lookup_BioShock_Infinite_result()
           }}
        end do
        conn = get(conn, ~p"/wishlist/#{fav.id}")
        assert html_response(conn, 200) =~ "BioShock Infinite"
        assert html_response(conn, 200) =~ "This game is on sale!"
        assert html_response(conn, 200) =~ "Get the latest deal for $5.39"
        assert html_response(conn, 200) =~ "Available"
        assert html_response(conn, 200) =~ "at GameBillet"
        assert html_response(conn, 200) =~ "Normal retail price: $29.99"

        assert html_response(conn, 200) =~
                 "Don't want to buy from GameBillet? Here are other options:"

        assert html_response(conn, 200) =~ "IndieGala"
        assert html_response(conn, 200) =~ "$5.49"
        assert html_response(conn, 200) =~ "Buy"
      end
    end

    test "does not display other users favorites", %{conn: conn} do
      conn = sign_up(conn)

      conn =
        with_mock HTTPoison,
          get: fn _url ->
            {:ok, %HTTPoison.Response{status_code: 200, body: deal_lookup_fetch_result()}}
          end do
          post(conn, ~p"/wishlist/new", %{"game" => %{"dealID" => "test_id"}})
        end

      [fav | _] = Favorites.list_user_favorites(conn.assigns.current_user.id)
      conn = delete(conn, ~p"/users/log_out")
      refute get_session(conn, :user_token)
      conn = sign_up(conn) |> get(~p"/wishlist/#{fav.id}")
      assert redirected_to(conn) == ~p"/wishlist"
      assert Phoenix.Flash.get(conn.assigns.flash, :error) =~ "That is not a valid ID"
    end

    test "does not display favorites that do not exist", %{conn: conn} do
      conn = sign_up(conn) |> get(~p"/wishlist/0")
      assert redirected_to(conn) == ~p"/wishlist"
      assert Phoenix.Flash.get(conn.assigns.flash, :error) =~ "That is not a valid ID"
    end

    test "fetches latest prices", %{conn: conn} do
      conn = sign_up(conn)

      conn =
        with_mock HTTPoison,
          get: fn _url ->
            {:ok, %HTTPoison.Response{status_code: 200, body: deal_lookup_fetch_result()}}
          end do
          post(conn, ~p"/wishlist/new", %{"game" => %{"dealID" => "test_id"}})
        end

      with_mock CheapSharkApi,
        fetch_all_for_user: fn _id, _email -> nil end do
        conn = get(conn, ~p"/wishlist/fetch")
        assert redirected_to(conn) == ~p"/wishlist"
        assert Phoenix.Flash.get(conn.assigns.flash, :info) =~ "Fetching latest prices for"
        assert_called(CheapSharkApi.fetch_all_for_user(:_, :_))
      end
    end
  end
end
