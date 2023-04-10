defmodule MediaWishlist.Repo.Migrations.CreateFavorites do
  use Ecto.Migration

  def change do
    create table(:favorites) do
      add :title, :string
      add :metacriticLink, :string
      add :dealID, :string
      add :storeID, :string
      add :gameID, :string
      add :steamAppID, :string
      add :currPrice, :integer
      add :onSale, :boolean, default: false, null: false
      add :thumb, :string
      add :user_id, references(:users, on_delete: :nothing)

      timestamps()
    end

    create index(:favorites, [:user_id])
  end
end
