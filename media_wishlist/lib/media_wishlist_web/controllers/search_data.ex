defmodule MediaWishlistWeb.SearchData do
  alias Ecto.Changeset

  @types %{search_param: :string}

  def validate(params) do
    {%{}, @types}
    |> Changeset.cast(params, Map.keys(@types))
    |> Changeset.validate_required([:search_param])
    |> Map.put(:action, :validate)
  end
end
