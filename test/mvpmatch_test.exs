defmodule MvpmatchTest do
  use ExUnit.Case, async: false
  alias Mvpmatch.Accounts
  alias Mvpmatch.Roles

  describe "create a full example" do

    setup do
      :ok = Ecto.Adapters.SQL.Sandbox.checkout(Mvpmatch.Repo)
    end

    test "Full test" do
      # create user1
      {:ok, user1} =
        Accounts.create_user("user1", "user1")

      # user1 is a buyer
      {:ok, buyer} =
        Roles.create_buyer(user1)

      # user1 adds 100 coins
      {:ok, _} =
        Roles.add_valid_coins(buyer.id, 100)

      # create user2
      {:ok, user2} =
        Accounts.create_user("user2", "user2")

      # user2 is a seller
      {:ok, seller} =
        Roles.create_seller(user2)

      # user2 creates a new products
      {:ok, product1} =
        Roles.create_product(seller, %{ name: "product1", amount: 10, cost: 1 })
      {:ok, product2} =
        Roles.create_product(seller, %{ name: "product2", amount: 15, cost: 10 })
      {:ok, product3} =
        Roles.create_product(seller, %{ name: "product3", amount: 100, cost: 20 })

      # user1 can buy some products
      {:ok, %{ buyer: buyer, product_amount: 1 }} =
        Roles.buy_product(buyer.id, product1.id)

      {:ok, %{ buyer: buyer, product_amount: 5 }} =
        Roles.buy_product(buyer.id, product2.id, 5)

    end
  end
end
