defmodule MediaWishlistWeb.FavoriteControllerTest do
  use MediaWishlistWeb.ConnCase

  import MediaWishlist.FavoritesFixtures

  @create_attrs %{cheapest_price: 42, name: "some name"}
  @update_attrs %{cheapest_price: 43, name: "some updated name"}
  @invalid_attrs %{cheapest_price: nil, name: nil}

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
      assert html_response(conn, 200) =~ "some updated name"
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
