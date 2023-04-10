defmodule MediaWishlist.Repo.Migrations.AddRetailPriceFieldToFavoritesTable do
  use Ecto.Migration

  def change do
    alter table("favorites") do
      add_if_not_exists :retailPrice, :integer
    end
  end
end
