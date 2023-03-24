defmodule MediaWishlistWeb.FavoriteControllerTest do
  use MediaWishlistWeb.ConnCase

  import MediaWishlist.FavoritesFixtures

  @create_attrs %{currPrice: 42, dealID: "some dealID", gameID: "some gameID", metacriticLink: "some metacriticLink", onSale: true, steamAppID: "some steamAppID", storeID: "some storeID", thumb: "some thumb", title: "some title"}
  @update_attrs %{currPrice: 43, dealID: "some updated dealID", gameID: "some updated gameID", metacriticLink: "some updated metacriticLink", onSale: false, steamAppID: "some updated steamAppID", storeID: "some updated storeID", thumb: "some updated thumb", title: "some updated title"}
  @invalid_attrs %{currPrice: nil, dealID: nil, gameID: nil, metacriticLink: nil, onSale: nil, steamAppID: nil, storeID: nil, thumb: nil, title: nil}

  describe "index" do
    test "lists all favorites", %{conn: conn} do
      conn = get(conn, ~p"/favorites")
      assert html_response(conn, 200) =~ "Listing Favorites"
    end
  end

  describe "new favorite" do
    test "renders form", %{conn: conn} do
      conn = get(conn, ~p"/favorites/new")
      assert html_response(conn, 200) =~ "New Favorite"
    end
  end

  describe "create favorite" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, ~p"/favorites", favorite: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == ~p"/favorites/#{id}"

      conn = get(conn, ~p"/favorites/#{id}")
      assert html_response(conn, 200) =~ "Favorite #{id}"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, ~p"/favorites", favorite: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Favorite"
    end
  end

  describe "edit favorite" do
    setup [:create_favorite]

    test "renders form for editing chosen favorite", %{conn: conn, favorite: favorite} do
      conn = get(conn, ~p"/favorites/#{favorite}/edit")
      assert html_response(conn, 200) =~ "Edit Favorite"
    end
  end

  describe "update favorite" do
    setup [:create_favorite]

    test "redirects when data is valid", %{conn: conn, favorite: favorite} do
      conn = put(conn, ~p"/favorites/#{favorite}", favorite: @update_attrs)
      assert redirected_to(conn) == ~p"/favorites/#{favorite}"

      conn = get(conn, ~p"/favorites/#{favorite}")
      assert html_response(conn, 200) =~ "some updated dealID"
    end

    test "renders errors when data is invalid", %{conn: conn, favorite: favorite} do
      conn = put(conn, ~p"/favorites/#{favorite}", favorite: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit Favorite"
    end
  end

  describe "delete favorite" do
    setup [:create_favorite]

    test "deletes chosen favorite", %{conn: conn, favorite: favorite} do
      conn = delete(conn, ~p"/favorites/#{favorite}")
      assert redirected_to(conn) == ~p"/favorites"

      assert_error_sent 404, fn ->
        get(conn, ~p"/favorites/#{favorite}")
      end
    end
  end

  defp create_favorite(_) do
    favorite = favorite_fixture()
    %{favorite: favorite}
  end
end
