defmodule MvpmatchWeb.DepositController do
  use MvpmatchWeb, :controller
  alias Mvpmatch.Accounts.User
  alias Mvpmatch.Roles
  alias Mvpmatch.Roles.Buyer

  @doc ~S"""
  """
  def info(conn, _params) do
    with user = %User{buyer: %Buyer{}} <- conn.assigns[:user] do
      conn
      |> json(%{deposit: user.buyer.deposit})
    else
      %User{buyer: nil} ->
        conn
        |> put_status(403)
        |> json(%{error: "you are not a buyer"})
      _ ->
        conn
        |> put_status(400)
        |> json(%{error: "invalid request"})
    end
  end

  @doc ~S"""
  """
  def add_coins(conn, %{ "coins" => coins }) do
    with user = %User{buyer: %Buyer{}} <- conn.assigns[:user],
         {:ok, buyer} <- Roles.add_valid_coins(user.buyer.id, coins) do
      conn
      |> json(%{deposit: buyer.deposit})
    else
      user = %User{buyer: nil} -> create_buyer(conn, user, coins)
      _ ->
        conn
        |> put_status(400)
        |> json(%{error: "invalid request"})
    end
  end

  defp create_buyer(conn, user = %User{}, coins) do
    with {:ok, buyer = %Buyer{}} <- Roles.create_buyer(user),
         {:ok, buyer = %Buyer{}} <- Roles.add_valid_coins(buyer.id, coins) do
      json(conn, %{deposit: buyer.deposit})
    end
  end

  @doc ~S"""
  """
  def reset(conn, _params) do
    with user = %User{} <- conn.assigns[:user],
         {:ok, buyer} <- Roles.reset_deposit(user.buyer) do
      conn
      |> json(%{deposit: buyer.deposit})
    else
      %User{buyer: nil} ->
        conn
        |> put_status(403)
        |> json(%{error: "you are not a buyer"})
      _ ->
        conn
        |> put_status(400)
        |> json(%{error: "invalid request"})
    end
  end
end
