defmodule MediaWishlistWeb.CheapSharkTest do
  use MediaWishlistWeb.ConnCase
  use ExUnit.Case
  import Mock
  import CheapSharkApi

  describe "cheapshark_api_fetch" do
    test "makes a call to the cheapshark api" do
      with_mock HTTPoison, [get: fn(url) -> {:ok, %HTTPoison.Response{status_code: 200, body: url}} end] do
        result = fetch_data("Test")
        assert result == "Test"
      end
    end
  end
end
