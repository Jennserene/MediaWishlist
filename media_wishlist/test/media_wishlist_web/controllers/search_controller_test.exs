defmodule MediaWishlistWeb.SearchControllerTest do
  use MediaWishlistWeb.ConnCase
  use ExUnit.Case
  import Mock
  import MediaWishlistWeb.SearchController
  import MediaWishlist.AccountsFixtures

  def log_in(conn) do
    user = user_fixture()
    post(conn, ~p"/users/log_in", %{
      "user" => %{"email" => user.email, "password" => valid_user_password()}
    })
  end

  describe "start" do
    test "provides a search box", %{conn: conn} do
      conn = log_in(conn)
      conn = get(conn, ~p"/search")
      assert html_response(conn, 200) =~ "Search for books on ebay"
    end
  end

  describe "ebay_api_fetch" do
    test "makes a call to the ebay api" do
      with_mock HTTPoison, [get: fn(url, _headers) -> {:ok, %HTTPoison.Response{status_code: 200, body: url}} end] do
        result = ebay_api_fetch("Test")
        assert result == "https://api.ebay.com/buy/browse/v1/item_summary/search?q=Test&category_ids=261186&limit=10"
      end
    end
  end
end
