defmodule MvpmatchWeb.UserController do
  use MvpmatchWeb, :controller
  alias Mvpmatch.Accounts
  alias Mvpmatch.Accounts.User
  alias Mvpmatch.Roles

  def create(conn, %{"username" => username, "password" => password}) do
    with {:ok, user = %User{}} <- Accounts.create_user(username, password) do
      json(conn, %{
            username: user.username,
            created_at: user.inserted_at,
            updated_at: user.updated_at
      })
    else
      _ ->
        conn
        |> put_status(400)
        |> json(%{ error: "can't create user" })
    end
  end
  def create(conn, _) do
    conn
    |> put_status(400)
    |> json(%{ error: "missing fields" })
  end

  def info(conn, _params) do
    case conn.assigns[:user] do
      user = %User{} ->
        json(conn, %{
              username: user.username,
              buyer: Roles.is_buyer?(user),
              seller: Roles.is_seller?(user)
             })
      elsewise ->
        json(conn, %{})
    end
  end
end
