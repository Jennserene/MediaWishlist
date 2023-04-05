defmodule MediaWishlistWeb.CheapSharkTest do
  use MediaWishlistWeb.ConnCase
  use ExUnit.Case, async: false
  import Mock
  import CheapSharkApi

  describe "cheapshark_api_fetch" do
    import MediaWishlist.CheapSharkFixtures
    import MediaWishlist.FavoritesFixtures

    test "makes a the correct call to the passed in URL" do
      with_mock HTTPoison,
        get: fn url -> {:ok, %HTTPoison.Response{status_code: 200, body: url}} end do
        result = fetch_data("Test")
        assert result == "Test"
      end
    end

    test_with_mock "search_deals makes the correct API call and decodes the JSON correctly",
                   HTTPoison,
                   get: fn _url ->
                     {:ok,
                      %HTTPoison.Response{status_code: 200, body: search_deals_fetch_result()}}
                   end do
      result = search_deals("bat man")

      assert result == search_deals_decode_result()

      assert_called(HTTPoison.get("https://www.cheapshark.com/api/1.0/games?title=bat%20man"))
    end

    test "convert_to_favorite correctly converts SingleDeal to map for updating favorite" do
      result = convert_to_favorite(deal_lookup_decode_result(), "test_id")

      assert result == convert_to_favorite_result()
    end

    test "deal_lookup makes the correct API call and decodes/converts the JSON correctly" do
      with_mocks([
        {HTTPoison, [],
         get: fn _url ->
           {:ok, %HTTPoison.Response{status_code: 200, body: deal_lookup_fetch_result()}}
         end},
        {CheapSharkApi, [:passthrough], convert_to_favorite: fn _deal, _id -> "converted" end}
      ]) do
        result = deal_lookup("test_id")
        assert result == "converted"

        assert_called(CheapSharkApi.convert_to_favorite(deal_lookup_decode_result(), "test_id"))
        assert_called(HTTPoison.get("https://www.cheapshark.com/api/1.0/deals?id=test_id"))
      end
    end

    test "convert_to_include_store_names correctly converts store names from IDs to store names" do
      result = convert_to_include_store_names(game_deals_lookup_decode_result())

      [first | _rest] = result.deals

      assert first.storeID == "Fanatical"
    end

    test "game_deals_lookup makes the correct API call and decodes/converts the JSON correctly" do
      with_mocks([
        {HTTPoison, [],
         get: fn _url ->
           {:ok, %HTTPoison.Response{status_code: 200, body: game_deals_lookup_fetch_result()}}
         end},
        {CheapSharkApi, [:passthrough],
         convert_to_include_store_names: fn _deals -> "converted" end}
      ]) do
        result = game_deals_lookup("123")
        assert result == "converted"

        assert_called(CheapSharkApi.convert_to_include_store_names(%{}))
        assert_called(HTTPoison.get("https://www.cheapshark.com/api/1.0/games?id=123"))
      end
    end

    test "store_name returns storeName attribute in map" do
      test_map = %{foo: "bar", storeName: "test name"}
      result = store_name(test_map)
      assert result == "test name"
    end

    test "retrieve_store gets store from json file" do
      with_mock File, read!: fn _path -> stores_json() end do
        result = retrieve_store("1")
        assert result.storeName == "Steam"
      end
    end

    test "retrieve_store_wrapper fetches and writes new store data when store does not exist" do
      with_mocks([
        {HTTPoison, [],
         get: fn _url ->
           {:ok, %HTTPoison.Response{status_code: 200, body: foobar_stores_fetch_result()}}
         end},
        {CheapSharkApi, [:passthrough],
         retrieve_store: fn _storeID -> nil end, store_name: fn _store -> "Foobar" end},
        {File, [], write!: fn _path, _store_data -> :ok end}
      ]) do
        result = retrieve_store_wrapper("99999")

        assert result == "Foobar"
        assert_called(HTTPoison.get("https://www.cheapshark.com/api/1.0/stores"))
        assert_called(File.write!(:_, foobar_stores_fetch_result()))
        assert_called(CheapSharkApi.retrieve_store("99999"))
        assert_called(CheapSharkApi.store_name(nil))
      end
    end

    test "fetch_users_latest_prices updates local favorite with correct parameters" do
      with_mocks([
        {HTTPoison, [],
         get: fn _url ->
           {:ok,
            %HTTPoison.Response{status_code: 200, body: fetch_users_latest_prices_fetch_result()}}
         end},
        {CheapSharkApi, [:passthrough],
         merge_into_favorite: fn _game, _new_deals, _email -> favorite_fixture() end}
      ]) do
        result = List.first(fetch_users_latest_prices([%{gameID: "128"}], "foo@bar.com"))

        assert result.dealID == "some dealID"
        assert_called(HTTPoison.get("https://www.cheapshark.com/api/1.0/games?ids=128"))
        assert_called(CheapSharkApi.merge_into_favorite(%{}, %{}, "foo@bar.com"))
      end
    end
  end
end
