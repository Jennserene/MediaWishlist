defmodule MediaWishlist.ItemsTest do
  use MediaWishlist.DataCase

  alias MediaWishlist.Items

  describe "items" do
    alias MediaWishlist.Items.Item

    import MediaWishlist.ItemsFixtures

    @invalid_attrs %{condition: nil, image_url: nil, item_id: nil, item_url: nil, price: nil, title: nil}

    test "list_items/0 returns all items" do
      item = item_fixture()
      assert Items.list_items() == [item]
    end

    test "get_item!/1 returns the item with given id" do
      item = item_fixture()
      assert Items.get_item!(item.id) == item
    end

    test "create_item/1 with valid data creates a item" do
      valid_attrs = %{condition: "some condition", image_url: "some image_url", item_id: "some item_id", item_url: "some item_url", price: 42, title: "some title"}

      assert {:ok, %Item{} = item} = Items.create_item(valid_attrs)
      assert item.condition == "some condition"
      assert item.image_url == "some image_url"
      assert item.item_id == "some item_id"
      assert item.item_url == "some item_url"
      assert item.price == 42
      assert item.title == "some title"
    end

    test "create_item/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Items.create_item(@invalid_attrs)
    end

    test "update_item/2 with valid data updates the item" do
      item = item_fixture()
      update_attrs = %{condition: "some updated condition", image_url: "some updated image_url", item_id: "some updated item_id", item_url: "some updated item_url", price: 43, title: "some updated title"}

      assert {:ok, %Item{} = item} = Items.update_item(item, update_attrs)
      assert item.condition == "some updated condition"
      assert item.image_url == "some updated image_url"
      assert item.item_id == "some updated item_id"
      assert item.item_url == "some updated item_url"
      assert item.price == 43
      assert item.title == "some updated title"
    end

    test "update_item/2 with invalid data returns error changeset" do
      item = item_fixture()
      assert {:error, %Ecto.Changeset{}} = Items.update_item(item, @invalid_attrs)
      assert item == Items.get_item!(item.id)
    end

    test "delete_item/1 deletes the item" do
      item = item_fixture()
      assert {:ok, %Item{}} = Items.delete_item(item)
      assert_raise Ecto.NoResultsError, fn -> Items.get_item!(item.id) end
    end

    test "change_item/1 returns a item changeset" do
      item = item_fixture()
      assert %Ecto.Changeset{} = Items.change_item(item)
    end
  end
end
