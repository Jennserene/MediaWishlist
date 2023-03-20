defmodule MediaWishlist.Items.Item do
  use Ecto.Schema
  import Ecto.Changeset

  schema "items" do
    field :condition, :string
    field :image_url, :string
    field :item_id, :string
    field :item_url, :string
    field :price, :integer
    field :title, :string
    field :favorite_id, :id

    timestamps()
  end

  @doc false
  def changeset(item, attrs) do
    item
    |> cast(attrs, [:item_id, :title, :item_url, :image_url, :price, :condition])
    |> validate_required([:item_id, :title, :item_url, :image_url, :price, :condition])
  end
end
