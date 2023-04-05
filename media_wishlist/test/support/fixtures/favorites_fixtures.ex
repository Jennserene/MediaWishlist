defmodule MediaWishlist.FavoritesFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `MediaWishlist.Favorites` context.
  """

  @doc """
  Generate a favorite.
  """
  def favorite_fixture(attrs \\ %{}) do
    {:ok, favorite} =
      attrs
      |> Enum.into(%{
        currPrice: "42.99",
        retailPrice: "24.99",
        dealID: "some dealID",
        gameID: "some gameID",
        metacriticLink: "some metacriticLink",
        onSale: true,
        steamAppID: "some steamAppID",
        storeID: "some storeID",
        thumb: "some thumb",
        title: "some title"
      })
      |> MediaWishlist.Favorites.create_favorite()

    favorite
  end

  def favorite_fixture_user(attrs \\ %{}) do
    {:ok, favorite} =
      attrs
      |> Enum.into(%{
        user_id: 1,
        currPrice: "42.99",
        retailPrice: "24.99",
        dealID: "some dealID",
        gameID: "some gameID",
        metacriticLink: "some metacriticLink",
        onSale: true,
        steamAppID: "some steamAppID",
        storeID: "some storeID",
        thumb: "some thumb",
        title: "some title"
      })
      |> MediaWishlist.Favorites.create_favorite()

    favorite
  end
end
