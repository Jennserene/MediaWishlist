defmodule MediaWishlistWeb.FavoriteController do
  use MediaWishlistWeb, :controller

  alias MediaWishlist.Favorites
  alias MediaWishlist.Favorites.Favorite

  def index(conn, _params) do
    favorites = Favorites.list_favorites()
    render(conn, :index, favorites: favorites)
  end

  def new(conn, _params) do
    changeset = Favorites.change_favorite(%Favorite{})
    render(conn, :new, changeset: changeset)
  end

  def create(conn, %{"favorite" => favorite_params}) do
    case Favorites.create_favorite(favorite_params) do
      {:ok, favorite} ->
        conn
        |> put_flash(:info, "Favorite created successfully.")
        |> redirect(to: ~p"/favorites/#{favorite}")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :new, changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    favorite = Favorites.get_favorite!(id)
    render(conn, :show, favorite: favorite)
  end

  def edit(conn, %{"id" => id}) do
    favorite = Favorites.get_favorite!(id)
    changeset = Favorites.change_favorite(favorite)
    render(conn, :edit, favorite: favorite, changeset: changeset)
  end

  def update(conn, %{"id" => id, "favorite" => favorite_params}) do
    favorite = Favorites.get_favorite!(id)

    case Favorites.update_favorite(favorite, favorite_params) do
      {:ok, favorite} ->
        conn
        |> put_flash(:info, "Favorite updated successfully.")
        |> redirect(to: ~p"/favorites/#{favorite}")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :edit, favorite: favorite, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    favorite = Favorites.get_favorite!(id)
    {:ok, _favorite} = Favorites.delete_favorite(favorite)

    conn
    |> put_flash(:info, "Favorite deleted successfully.")
    |> redirect(to: ~p"/favorites")
  end
end
