defmodule MediaWishlist.Repo.Migrations.CreateFavorites do
  use Ecto.Migration

  def change do
    create table(:favorites) do
      add :name, :string
      add :cheapest_price, :integer
      add :user_id, references(:users, on_delete: :nothing)

      timestamps()
    end

    create index(:favorites, [:user_id])
  end
end
