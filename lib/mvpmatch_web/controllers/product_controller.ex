defmodule MvpmatchWeb.ProductController do
  @moduledoc ~S"""
  """
  use MvpmatchWeb, :controller
  alias Mvpmatch.Accounts
  alias Mvpmatch.Accounts.User
  alias Mvpmatch.Roles
  alias Mvpmatch.Roles.Buyer
  alias Mvpmatch.Roles.Seller
  alias Mvpmatch.Roles.Product

  @doc ~S"""
  """
  def list_all(conn, _params) do
    json(conn,
      Roles.list_products()
      |> Enum.map(&product_to_json/1)
    )
  end

  @doc ~S"""
  """
  def create(conn, params) do
    with user = %User{seller: %Seller{}} <- conn.assigns[:user],
         {:ok, product} <- Roles.create_product(user.seller, params) do
      json(conn, product_to_json(product))
    else
      user = %User{seller: nil} ->
        create_seller(conn, user, params)
      _ ->
        conn
        |> put_status(500)
        |> json(%{error: "can't create product"})
    end
  end

  @doc ~S"""
  """
  defp create_seller(conn, user, params) do
    with {:ok, seller = %Seller{}} <- Roles.create_seller(user),
         {:ok, product} <- Roles.create_product(seller, params) do
      json(conn, product_to_json(product))
    else
      _ ->
        conn
        |> put_status(500)
        |> json(%{error: "can't create product"})
    end
  end

  @doc ~S"""
  """
  def update(conn, params) do
    with product_id <- Map.get(params, "product_id", {:error, ["missing id"]}),
         user = %User{seller: %Seller{}} <- conn.assigns[:user],
         {:ok, product} <- Roles.update_product(user.seller, product_id, params) do
      json(conn, product_to_json(product))
    else
      %User{seller: nil} ->
        conn
        |> put_status(400)
        |> json(%{error: "you are not a seller"})
      {:error, "unauthorized"} ->
        conn
        |> put_status(403)
        |> json(%{error: "unauthorized"})
      nil ->
        conn
        |> put_status(404)
        |> json(%{error: "not found"})
      _ ->
        conn
        |> put_status(500)
        |> json(%{error: "internal server error"})
    end
  end

  @doc ~S"""
  """
  def delete(conn, params) do
    with product_id <- Map.get(params, "product_id", {:error, ["missing id"]}),
         user = %User{seller: %Seller{}} <- conn.assigns[:user],
         {:ok, product} <- Roles.delete_product(user.seller, product_id) do
      json(conn, product_to_json(product))
    else
      %User{seller: nil} ->
        conn
        |> put_status(400)
        |> json(%{error: "you are not a seller"})
      {:error, "unauthorized"} ->
        conn
        |> put_status(403)
        |> json(%{error: "unauthorized"})
      nil ->
        conn
        |> put_status(404)
        |> json(%{error: "not found"})
      _ ->
        conn
        |> put_status(500)
        |> json(%{error: "internal server error"})
    end
  end

  @doc ~S"""
  """
  defp product_to_json(%Product{} = product) do
    %{
      id: product.id,
      name: product.name,
      amount: product.amount,
      cost: product.cost,
      inserted_at: product.inserted_at,
      updated_at: product.updated_at
    }
  end

  def buy_product(conn, params) do
    with product_id <- Map.get(params, "product_id", {:error, ["missing id"]}),
         amount <- Map.get(params, "amount", 1),
         user = %User{buyer: %Buyer{}} <- conn.assigns[:user],
         {:ok, result} <- Roles.buy_product(user.buyer.id, product_id, amount) do
      json(conn, %{
            deposity: result.buyer.deposit,
            product_amount: result.product_amount,
            product: product_to_json(result.product),
      })
    else
      %User{buyer: nil} ->
        conn
        |> put_status(400)
        |> json(%{error: "you are not a buyer"})
      {:error, reason} when is_binary(reason) ->
        conn
        |> put_status(400)
        |> json(%{error: reason})
      _ ->
        conn
        |> put_status(500)
        |> json(%{error: "internal server error"})
    end
  end
end
