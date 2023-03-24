defmodule MediaWishlist.FavoritesTest do
  use MediaWishlist.DataCase

  alias MediaWishlist.Favorites

  describe "favorites" do
    alias MediaWishlist.Favorites.Favorite

    import MediaWishlist.FavoritesFixtures

    @invalid_attrs %{currPrice: nil, dealID: nil, gameID: nil, metacriticLink: nil, onSale: nil, steamAppID: nil, storeID: nil, thumb: nil, title: nil}

    test "list_favorites/0 returns all favorites" do
      favorite = favorite_fixture()
      assert Favorites.list_favorites() == [favorite]
    end

    test "get_favorite!/1 returns the favorite with given id" do
      favorite = favorite_fixture()
      assert Favorites.get_favorite!(favorite.id) == favorite
    end

    test "create_favorite/1 with valid data creates a favorite" do
      valid_attrs = %{currPrice: 42, dealID: "some dealID", gameID: "some gameID", metacriticLink: "some metacriticLink", onSale: true, steamAppID: "some steamAppID", storeID: "some storeID", thumb: "some thumb", title: "some title"}

      assert {:ok, %Favorite{} = favorite} = Favorites.create_favorite(valid_attrs)
      assert favorite.currPrice == 42
      assert favorite.dealID == "some dealID"
      assert favorite.gameID == "some gameID"
      assert favorite.metacriticLink == "some metacriticLink"
      assert favorite.onSale == true
      assert favorite.steamAppID == "some steamAppID"
      assert favorite.storeID == "some storeID"
      assert favorite.thumb == "some thumb"
      assert favorite.title == "some title"
    end

    test "create_favorite/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Favorites.create_favorite(@invalid_attrs)
    end

    test "update_favorite/2 with valid data updates the favorite" do
      favorite = favorite_fixture()
      update_attrs = %{currPrice: 43, dealID: "some updated dealID", gameID: "some updated gameID", metacriticLink: "some updated metacriticLink", onSale: false, steamAppID: "some updated steamAppID", storeID: "some updated storeID", thumb: "some updated thumb", title: "some updated title"}

      assert {:ok, %Favorite{} = favorite} = Favorites.update_favorite(favorite, update_attrs)
      assert favorite.currPrice == 43
      assert favorite.dealID == "some updated dealID"
      assert favorite.gameID == "some updated gameID"
      assert favorite.metacriticLink == "some updated metacriticLink"
      assert favorite.onSale == false
      assert favorite.steamAppID == "some updated steamAppID"
      assert favorite.storeID == "some updated storeID"
      assert favorite.thumb == "some updated thumb"
      assert favorite.title == "some updated title"
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
