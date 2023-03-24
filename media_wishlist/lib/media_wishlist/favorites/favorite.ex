defmodule MediaWishlist.Favorites.Favorite do
  use Ecto.Schema
  import Ecto.Changeset

  schema "favorites" do
    field :currPrice, :integer
    field :dealID, :string
    field :gameID, :string
    field :metacriticLink, :string
    field :onSale, :boolean, default: false
    field :steamAppID, :string
    field :storeID, :string
    field :thumb, :string
    field :title, :string
    field :user_id, :id

    timestamps()
  end

  @doc false
  def changeset(favorite, attrs) do
    favorite
    |> cast(attrs, [:title, :metacriticLink, :dealID, :storeID, :gameID, :steamAppID, :currPrice, :onSale, :thumb])
    |> validate_required([:title, :metacriticLink, :dealID, :storeID, :gameID, :steamAppID, :currPrice, :onSale, :thumb])
  end
end
