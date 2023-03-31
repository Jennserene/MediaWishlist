defmodule MediaWishlist.Favorites do
  @moduledoc """
  The Favorites context.
  """

  import Ecto.Query, warn: false
  require Logger

  alias MediaWishlist.Repo

  alias MediaWishlist.Favorites.Favorite

  @doc """
  Returns the list of favorites.

  ## Examples

      iex> list_favorites()
      [%Favorite{}, ...]

  """
  def list_favorites do
    Repo.all(Favorite)
  end

  @doc """
  Gets a single favorite.

  Raises `Ecto.NoResultsError` if the Favorite does not exist.

  ## Examples

      iex> get_favorite!(123)
      %Favorite{}

      iex> get_favorite!(456)
      ** (Ecto.NoResultsError)

  """

  def list_user_favorites(user_id) do
    query =
      from(f in Favorite,
        where: f.user_id == ^user_id
      )

    Repo.all(query)
  end

  def get_favorite!(id), do: Repo.get!(Favorite, id)

  @doc """
  Creates a favorite.

  ## Examples

      iex> create_favorite(%{field: value})
      {:ok, %Favorite{}}

      iex> create_favorite(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_favorite(attrs \\ %{}) do
    %Favorite{}
    |> Favorite.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a favorite.

  ## Examples

      iex> update_favorite(favorite, %{field: new_value})
      {:ok, %Favorite{}}

      iex> update_favorite(favorite, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_favorite(%Favorite{} = favorite, attrs) do
    favorite
    |> Favorite.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a favorite.

  ## Examples

      iex> delete_favorite(favorite)
      {:ok, %Favorite{}}

      iex> delete_favorite(favorite)
      {:error, %Ecto.Changeset{}}

  """
  def delete_favorite(%Favorite{} = favorite) do
    Repo.delete(favorite)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking favorite changes.

  ## Examples

      iex> change_favorite(favorite)
      %Ecto.Changeset{data: %Favorite{}}

  """
  def change_favorite(%Favorite{} = favorite, attrs \\ %{}) do
    Favorite.changeset(favorite, attrs)
  end

  def list_user_chunked_favorites(id) do
    list_user_favorites(id)
    |> Enum.chunk_every(25)
  end

  def update_local_favorite(favorite, best) when favorite.dealID != best.dealID do
    new_favorite = %{
      storeID: best.storeID,
      dealID: best.dealID,
      currPrice: best.price,
      retailPrice: best.retailPrice,
      onSale: Float.parse(best.price) < Float.parse(best.retailPrice),
      gameID: favorite.gameID,
      metacriticLink: favorite.metacriticLink,
      steamAppID: favorite.steamAppID,
      thumb: favorite.thumb,
      title: favorite.title,
      user_id: favorite.user_id
    }

    {:changed, new_favorite}
  end

  def update_local_favorite(favorite, best) when favorite.dealID == best.dealID do
    {:same, favorite}
  end

  def update_favorite_wrapper(email, orig_fav, new_fav) do
    case update_favorite(orig_fav, new_fav) do
      {:ok, favorite} ->
        Logger.info("Updated #{favorite.title} in #{email} with latest deal Successfully.")

      {:error, %Ecto.Changeset{} = changeset} ->
        Logger.error("Something went wrong updating a favorite with a new deal!")
        Logger.error(IO.inspect(changeset))
    end
  end

  def update_local_favorite_wrapper(email, orig_favorite, best) do
    case update_local_favorite(orig_favorite, best) do
      {:changed, new_favorite} ->
        update_favorite_wrapper(email, orig_favorite, new_favorite)
        new_favorite

      {:same, same_favorite} ->
        Logger.debug("#{same_favorite.title} is already up to date")
        same_favorite
    end
  end
end
