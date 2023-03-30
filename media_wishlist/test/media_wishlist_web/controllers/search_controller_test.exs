defmodule MediaWishlistWeb.SearchControllerTest do
  use MediaWishlistWeb.ConnCase
  use ExUnit.Case
  import MediaWishlist.AccountsFixtures

  def log_in(conn) do
    user = user_fixture()

    post(conn, ~p"/users/log_in", %{
      "user" => %{"email" => user.email, "password" => valid_user_password()}
    })
  end

  # describe "start" do
  #   test "provides a search box", %{conn: conn} do
  #     conn = log_in(conn)
  #     conn = get(conn, ~p"/search")
  #     assert html_response(conn, 200) =~ "Get started searching for games with the search box in the upper right corner!"
  #   end
  # end
end
