defmodule MediaWishlist.Favorites.Favorite do
  use Ecto.Schema
  import Ecto.Changeset
  alias MediaWishlist.Accounts.User

  schema "favorites" do
    field :currPrice, :string
    field :retailPrice, :string
    field :dealID, :string
    field :gameID, :string
    field :metacriticLink, :string
    field :onSale, :boolean, default: false
    field :steamAppID, :string
    field :storeID, :string
    field :thumb, :string
    field :title, :string

    belongs_to :user, User

    timestamps()
  end

  @doc false
  def changeset(favorite, attrs) do
    favorite
    |> cast(attrs, [:title, :metacriticLink, :dealID, :storeID, :gameID, :steamAppID, :currPrice, :retailPrice, :onSale, :thumb, :user_id])
    |> validate_required([:title, :dealID, :storeID, :gameID, :currPrice, :retailPrice, :onSale, :thumb])
  end
end
