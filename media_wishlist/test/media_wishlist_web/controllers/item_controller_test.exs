defmodule MediaWishlistWeb.ItemControllerTest do
  use MediaWishlistWeb.ConnCase

  import MediaWishlist.ItemsFixtures

  @create_attrs %{condition: "some condition", image_url: "some image_url", item_id: "some item_id", item_url: "some item_url", price: 42, title: "some title"}
  @update_attrs %{condition: "some updated condition", image_url: "some updated image_url", item_id: "some updated item_id", item_url: "some updated item_url", price: 43, title: "some updated title"}
  @invalid_attrs %{condition: nil, image_url: nil, item_id: nil, item_url: nil, price: nil, title: nil}

  describe "index" do
    test "lists all items", %{conn: conn} do
      conn = get(conn, ~p"/items")
      assert html_response(conn, 200) =~ "Listing Items"
    end
  end

  describe "new item" do
    test "renders form", %{conn: conn} do
      conn = get(conn, ~p"/items/new")
      assert html_response(conn, 200) =~ "New Item"
    end
  end

  describe "create item" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, ~p"/items", item: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == ~p"/items/#{id}"

      conn = get(conn, ~p"/items/#{id}")
      assert html_response(conn, 200) =~ "Item #{id}"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, ~p"/items", item: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Item"
    end
  end

  describe "edit item" do
    setup [:create_item]

    test "renders form for editing chosen item", %{conn: conn, item: item} do
      conn = get(conn, ~p"/items/#{item}/edit")
      assert html_response(conn, 200) =~ "Edit Item"
    end
  end

  describe "update item" do
    setup [:create_item]

    test "redirects when data is valid", %{conn: conn, item: item} do
      conn = put(conn, ~p"/items/#{item}", item: @update_attrs)
      assert redirected_to(conn) == ~p"/items/#{item}"

      conn = get(conn, ~p"/items/#{item}")
      assert html_response(conn, 200) =~ "some updated condition"
    end

    test "renders errors when data is invalid", %{conn: conn, item: item} do
      conn = put(conn, ~p"/items/#{item}", item: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit Item"
    end
  end

  describe "delete item" do
    setup [:create_item]

    test "deletes chosen item", %{conn: conn, item: item} do
      conn = delete(conn, ~p"/items/#{item}")
      assert redirected_to(conn) == ~p"/items"

      assert_error_sent 404, fn ->
        get(conn, ~p"/items/#{item}")
      end
    end
  end

  defp create_item(_) do
    item = item_fixture()
    %{item: item}
  end
end
