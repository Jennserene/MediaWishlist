defmodule MediaWishlist.Repo.Migrations.ChangePricesToStrings do
  use Ecto.Migration

  def change do
    alter table("favorites") do
      modify :currPrice, :string
      modify :retailPrice, :string
    end
  end
end
