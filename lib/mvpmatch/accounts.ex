defmodule Mvpmatch.Accounts do
  @moduledoc ~S"""
  Interface to manage accounts (users).
  """
  alias Mvpmatch.Repo
  alias Mvpmatch.Accounts.User

  @doc ~S"""
  Creates new user using username and password.
  """
  @spec create_user(String.t(), String.t(), map()) :: %User{}
  def create_user(username, password, args \\ %{}) do
    role = Map.get(args, "role", nil)
    %User{}
    |> User.changeset(%{
      username: username,
      password: Argon2.hash_pwd_salt(password),
      role: role
    })
    |> Repo.insert()
  end

  @doc ~S"""
  Get an user by its id.
  """
  @spec get_user(String.t()) :: %User{}
  def get_user(user_id) do
    User
    |> Repo.get(user_id)
    |> Repo.preload([:buyer, [seller: :product]])
  end

  @doc ~S"""
  Get an user by its username.
  """
  @spec get_user_by_username(String.t()) :: %User{}
  def get_user_by_username(username) do
    User
    |> Repo.get_by(username: username)
    |> Repo.preload([:buyer, [seller: :product]])
  end

  @doc ~S"""
  Check if an username/password is valid based on the information stored
  in the database.

  ## Examples

      iex> check_password("username", "test")
      true
  """
  # @spec check_password(String.t(), String.t()) :: boolean()
  def check_password(username, password) do
    with user = %User{ password: hash } <- get_user_by_username(username) do
      case Argon2.verify_pass(password, hash) do
        true -> user
        false -> nil
      end
    else
      _ -> nil
    end
  end

  @doc ~S"""
  Configures an user role.

  ## Examples

      iex> update_user_role("username", "buyer")
      %User{}

      iex> update_user_role("username", "seller")
      %User{}
  """
  @spec update_user_role(String.t(), String.t()) :: %User{}
  def update_user_role(username, role) do
    with user = %User{} <- get_user_by_username(username) do
      user
      |> User.changeset(%{ role: role })
      |> Repo.update()
    end
  end
end
