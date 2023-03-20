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
        cheapest_price: 42,
        name: "some name"
      })
      |> MediaWishlist.Favorites.create_favorite()

    favorite
  end
end
