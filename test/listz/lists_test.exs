defmodule Listz.ListsTest do
  use Listz.DataCase

  alias Listz.Lists

  describe "lists" do
    alias Listz.Lists.List

    @valid_attrs %{description: "some description", title: "some title"}
    @update_attrs %{description: "some updated description", title: "some updated title"}
    @invalid_attrs %{description: nil, slug: nil, title: nil}

    def list_fixture(attrs \\ %{}) do
      {:ok, list} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Lists.create_list()

      list
    end

    test "list_lists/0 returns all lists" do
      list = list_fixture()
      assert Lists.list_lists() == [list]
    end

    test "get_list!/1 returns the list with given id" do
      list = list_fixture()
      assert Lists.get_list!(list.id) == list
    end

    test "with_tasks/1 returns the tasks association for a single list" do
      list = list_fixture()
      assert %List{tasks: %Ecto.Association.NotLoaded{}} = list
      assert %List{tasks: []} = Lists.with_tasks(list)
    end

    test "with_tasks/1 returns the tasks association for a list of lists" do
      list = list_fixture()
      assert [%List{tasks: []}] = Lists.with_tasks([list])
    end

    test "get_list_by_slug!/1 returns the list with given slug" do
      list = list_fixture()
      assert Lists.get_list_by_slug!(list.slug) == list
    end

    test "create_list/1 with valid data creates a list" do
      assert {:ok, %List{} = list} = Lists.create_list(@valid_attrs)
      assert list.description == "some description"
      assert list.slug == "some-title"
      assert list.title == "some title"
    end

    test "create_list/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Lists.create_list(@invalid_attrs)
    end

    test "create_list/1 with duplicate title returns error changeset" do
      Lists.create_list(@valid_attrs)
      assert {:error, %Ecto.Changeset{}} = Lists.create_list(@valid_attrs)
    end

    test "update_list/2 with valid data updates the list" do
      list = list_fixture()
      assert {:ok, %List{} = list} = Lists.update_list(list, @update_attrs)
      assert list.description == "some updated description"
      assert list.slug == "some-updated-title"
      assert list.title == "some updated title"
    end

    test "update_list/2 with invalid data returns error changeset" do
      list = list_fixture()
      assert {:error, %Ecto.Changeset{}} = Lists.update_list(list, @invalid_attrs)
      assert list == Lists.get_list!(list.id)
    end

    test "delete_list/1 deletes the list" do
      list = list_fixture()
      assert {:ok, %List{}} = Lists.delete_list(list)
      assert_raise Ecto.NoResultsError, fn -> Lists.get_list!(list.id) end
    end

    test "change_list/1 returns a list changeset" do
      list = list_fixture()
      assert %Ecto.Changeset{} = Lists.change_list(list)
    end
  end
end
