defmodule MvpmatchWeb.UserController do
  use MvpmatchWeb, :controller
  alias Mvpmatch.Accounts
  alias Mvpmatch.Accounts.User
  alias Mvpmatch.Roles
  alias Mvpmatch.Token

  @doc ~S"""
  Creates a new user and returns created value from the database.
  """
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

  @doc ~S"""
  Returns user information
  """
  def info(conn, _params) do
    case conn.assigns[:user] do
      user = %User{} ->
        json(conn, %{
              username: user.username,
              buyer: Roles.is_buyer?(user),
              seller: Roles.is_seller?(user)
             })
      _elsewise ->
        json(conn, %{})
    end
  end

  @doc ~S"""
  Creates a new session if credentials are valid.
  """
  def login(conn, %{"username" => username, "password" => password} = _params) do
    with user = %User{} <- Accounts.check_password(username, password),
      {:ok, jwt, _} <- Token.create_user_session(user) do
      conn
      |> put_resp_cookie("_mvpmatch_session", jwt, http_only: true)
      |> json(%{ logged: true })
    end
  end
end
