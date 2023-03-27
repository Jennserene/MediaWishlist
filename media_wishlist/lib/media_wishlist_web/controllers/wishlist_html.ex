defmodule MediaWishlistWeb.WishlistHTML do
  use MediaWishlistWeb, :html
  import Phoenix.HTML.Form
  import Phoenix.HTML.Link

  embed_templates("wishlist_html/*")
end
