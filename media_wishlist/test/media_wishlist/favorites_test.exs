defmodule MediaWishlist.FavoritesTest do
  use MediaWishlist.DataCase

  alias MediaWishlist.Favorites

  describe "favorites" do
    alias MediaWishlist.Favorites.Favorite

    import MediaWishlist.FavoritesFixtures

    @invalid_attrs %{cheapest_price: nil, name: nil}

    test "list_favorites/0 returns all favorites" do
      favorite = favorite_fixture()
      assert Favorites.list_favorites() == [favorite]
    end

    test "get_favorite!/1 returns the favorite with given id" do
      favorite = favorite_fixture()
      assert Favorites.get_favorite!(favorite.id) == favorite
    end

    test "create_favorite/1 with valid data creates a favorite" do
      valid_attrs = %{cheapest_price: 42, name: "some name"}

      assert {:ok, %Favorite{} = favorite} = Favorites.create_favorite(valid_attrs)
      assert favorite.cheapest_price == 42
      assert favorite.name == "some name"
    end

    test "create_favorite/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Favorites.create_favorite(@invalid_attrs)
    end

    test "update_favorite/2 with valid data updates the favorite" do
      favorite = favorite_fixture()
      update_attrs = %{cheapest_price: 43, name: "some updated name"}

      assert {:ok, %Favorite{} = favorite} = Favorites.update_favorite(favorite, update_attrs)
      assert favorite.cheapest_price == 43
      assert favorite.name == "some updated name"
    end

    test "update_favorite/2 with invalid data returns error changeset" do
      favorite = favorite_fixture()
      assert {:error, %Ecto.Changeset{}} = Favorites.update_favorite(favorite, @invalid_attrs)
      assert favorite == Favorites.get_favorite!(favorite.id)
    end

    test "delete_favorite/1 deletes the favorite" do
      favorite = favorite_fixture()
      assert {:ok, %Favorite{}} = Favorites.delete_favorite(favorite)
      assert_raise Ecto.NoResultsError, fn -> Favorites.get_favorite!(favorite.id) end
    end

    test "change_favorite/1 returns a favorite changeset" do
      favorite = favorite_fixture()
      assert %Ecto.Changeset{} = Favorites.change_favorite(favorite)
    end
  end
end
