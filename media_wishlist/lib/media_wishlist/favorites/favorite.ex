defmodule MediaWishlist.Favorites.Favorite do
  use Ecto.Schema
  import Ecto.Changeset

  schema "favorites" do
    field :cheapest_price, :integer
    field :name, :string
    field :user_id, :id

    timestamps()
  end

  @doc false
  def changeset(favorite, attrs) do
    favorite
    |> cast(attrs, [:name, :cheapest_price])
    |> validate_required([:name, :cheapest_price])
  end
end
