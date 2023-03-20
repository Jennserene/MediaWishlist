defmodule MediaWishlist.Repo.Migrations.CreateItems do
  use Ecto.Migration

  def change do
    create table(:items) do
      add :item_id, :string
      add :title, :string
      add :item_url, :string
      add :image_url, :string
      add :price, :integer
      add :condition, :string
      add :favorite_id, references(:favorites, on_delete: :nothing)

      timestamps()
    end

    create index(:items, [:favorite_id])
  end
end
