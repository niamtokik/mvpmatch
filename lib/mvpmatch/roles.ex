defmodule Mvpmatch.Roles do
  @moduledoc ~S"""
  """
  import Ecto.Query
  import Mvpmatch.Repo
  alias Mvpmatch.Repo
  alias Mvpmatch.Accounts.User
  alias Mvpmatch.Roles.Buyer
  alias Mvpmatch.Roles.Seller
  alias Mvpmatch.Roles.Product

  @doc ~S"""
  """
  @spec is_buyer?(%User{}) :: boolean()
  def is_buyer?(%User{} = user) do
    case get_buyer_by_user(user) do
      nil -> false
      _ -> true
    end
  end

  @doc ~S"""
  """
  @spec create_buyer(%User{}) :: {:ok, %Buyer{}} | {:error, Ecto.Changeset.t()}
  def create_buyer(%User{} = user) do
    %Buyer{ user_id: user.id }
    |> Buyer.changeset(%{})
    |> Repo.insert()
  end

  @doc ~S"""
  """
  @spec list_buyers() :: [%Buyer{}]
  def list_buyers() do
    Repo.all(Buyer)
  end

  @doc ~S"""
  """
  @spec get_buyer(integer()) :: %Buyer{}
  def get_buyer(buyer_id) do
    Repo.get(Buyer, buyer_id)
  end

  @doc ~S"""
  """
  @spec get_buyer_by_user(%User{}) :: %Buyer{}
  def get_buyer_by_user(%User{} = user) do
    Repo.get_by(Buyer, user_id: user.id)
  end

  @doc ~S"""
  """
  @spec get_buyer_by_user_id(integer()) :: %Buyer{}
  def get_buyer_by_user_id(user_id) do
    Repo.get_by(Buyer, user_id: user_id)
  end

  @doc ~S"""
  """
  @spec valid_coins?(5 | 10 | 20 | 50 | 100) :: boolean()
  def valid_coins?(coins) do
    case coins do
      5 -> true
      10 -> true
      20 -> true
      50 -> true
      100 -> true
      _ -> false
    end
  end

  @doc ~S"""
  """
  @spec add_valid_coins(integer(), integer()) :: {:ok, %Buyer{}}
  def add_valid_coins(buyer_id, coins) do
    case valid_coins?(coins) do
      true -> add_coins(buyer_id, coins)
      false -> nil
    end
  end

  @doc ~S"""
  """
  @spec add_coins(integer(), integer()) :: {:ok, %Buyer{}}
  def add_coins(buyer_id, coins) do
    Repo.transaction(fn ->
      buyer = buyer_id
      |> get_buyer() || rollback("buyer not found")

      buyer
      |> Buyer.changeset(%{ deposit: buyer.deposit + coins })
      |> Repo.update!()
    end)
  end

  @doc ~S"""
  """
  def reset_deposit(%Buyer{} = buyer) do
    Repo.transaction(fn ->
      buyer
      |> Buyer.changeset(%{deposit: 0})
      |> Repo.update!()
    end)
  end

  @doc ~S"""
  """
  @spec is_seller?(%User{}) :: boolean()
  def is_seller?(%User{} = user) do
    case get_seller_by_user(user) do
      nil -> false
      _ -> true
    end
  end

  @doc ~S"""
  """
  def create_seller(%User{} = user) do
    %Seller{ user_id: user.id }
    |> Seller.changeset(%{})
    |> Repo.insert()
  end

  @doc ~S"""
  """
  def list_sellers() do
    Repo.all(Seller)
  end

  @doc ~S"""
  """
  def get_seller(seller_id) do
    Repo.get(Seller, seller_id)
  end

  @doc ~S"""
  """
  def get_seller_by_user(%User{} = user) do
    Repo.get_by(Seller, user_id: user.id)
  end

  @doc ~S"""
  """
  def create_product(%Seller{} = seller, params) do
    %Product{ seller_id: seller.id }
    |> Product.changeset(params)
    |> Repo.insert()
  end

  @doc ~S"""
  """
  def get_product(product_id) do
    Product
    |> Repo.get(product_id)
    |> Repo.preload(:seller)
  end

  def get_product_by_name(product_name) do
    Product
    |> Repo.get_by(name: product_name)
    |> Repo.preload(:seller)
  end

  @doc ~S"""
  """
  def list_products() do
    Repo.all(Product)
  end

  @doc ~S"""
  """
  def list_products_by_seller(%Seller{} = seller) do
    from(
      p in Product,
      where: p.seller_id == ^seller.id
    )
    |> Repo.all()
  end

  @doc ~S"""
  """
  @spec list_products_by_user(%User{}) :: [%Product{}]
  def list_products_by_user(%User{} = user) do
    from(
      p in Product,
      join: s in Seller,
      on: s.id == p.seller_id,
      join: u in User,
      on: s.user_id == u.id,
      where: u.id == ^user.id
    )
    |> Repo.all()
  end

  @doc ~S"""
  """
  def update_product(%Product{} = product, params) do
    product
    |> Product.changeset(params)
    |> Repo.update()
  end

  @doc ~S"""
  """
  @spec buy_product(integer(), integer(), integer()) :: {:ok, map()}
  def buy_product(buyer_id, product_id, amount \\ 1) do
    Repo.transaction(fn ->
      # we fetch the buyer based on its id to have the latest value
      buyer = get_buyer(buyer_id)
        || rollback("buyer not found")

      # we fetch the product based on its id to have the latest value
      product = get_product(product_id)
        || rollback("product not found")

      # we calculate the cost
      cost = product.cost*amount

      # a buyer can't buy its own product
      product.seller.user_id != buyer.user_id
        || rollback("a buyer can't buy his own products")

      # buyer deposit must be greater or equal than cost
      buyer.deposit >= (cost)
        || rollback("not enough coins")

      # product amount must be greater or equal to one
      product.amount >= amount
        || rollback("not enough products available")

      # calculate the new amount
      new_amount = product.amount-amount

      # we update the product amount
      product = product
      |> Product.changeset(%{amount: new_amount})
      |> Repo.update!()

      # we calculate the new deposit
      new_deposit = buyer.deposit-cost

      # we update buyer deposit
      buyer = buyer
      |> Buyer.changeset(%{deposit: new_deposit})
      |> Repo.update!()

      # we return both updated buyer and and a list of products
      %{
        buyer: buyer,
        product_amount: amount,
        product: product,
        cost: cost,
        products: (for _ <- 1..amount, do: product)
      }
    end)
  end

  @doc ~S"""
  """
  def update_product(seller = %Seller{}, product_id, params) do
    with product = %Product{} <- get_product(product_id),
         true <- seller.id == product.seller_id do
      product
      |> Product.changeset(params)
      |> Repo.update()
    else
      nil -> nil
      false -> {:error, "unauthorized"}
      _ -> nil
    end
  end

  @doc ~S"""
  """
  def delete_product(seller = %Seller{}, product_id) do
    with product = %Product{} <- get_product(product_id),
         true <- seller.id == product.seller_id do
      Repo.delete(product)
    else
      nil -> nil
      false -> {:error, "unauthorized"}
      _ -> nil
    end
  end
end
