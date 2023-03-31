defmodule MediaWishlist.Repo.Migrations.AddFetchDailyFieldToUsersTable do
  use Ecto.Migration

  def change do
    alter table("users") do
      add_if_not_exists(:fetch_daily, :boolean, default: false)
    end
  end
end
