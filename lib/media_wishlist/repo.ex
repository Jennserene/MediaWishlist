defmodule MediaWishlist.Repo do
  use Ecto.Repo,
    otp_app: :media_wishlist,
    adapter: Ecto.Adapters.Postgres
end
