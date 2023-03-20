defmodule MediaWishlist.ItemsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `MediaWishlist.Items` context.
  """

  @doc """
  Generate a item.
  """
  def item_fixture(attrs \\ %{}) do
    {:ok, item} =
      attrs
      |> Enum.into(%{
        condition: "some condition",
        image_url: "some image_url",
        item_id: "some item_id",
        item_url: "some item_url",
        price: 42,
        title: "some title"
      })
      |> MediaWishlist.Items.create_item()

    item
  end
end
