defmodule MediaWishlistWeb.FavoriteHTML do
  use MediaWishlistWeb, :html

  embed_templates "favorite_html/*"

  @doc """
  Renders a favorite form.
  """
  attr :changeset, Ecto.Changeset, required: true
  attr :action, :string, required: true

  def favorite_form(assigns)
end
