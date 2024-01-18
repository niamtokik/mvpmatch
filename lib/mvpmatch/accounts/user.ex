defmodule Mvpmatch.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset
  alias Mvpmatch.Roles.Buyer
  alias Mvpmatch.Roles.Seller

  schema "users" do
    field :username, :string
    field :password, :string
    has_one :buyer, Buyer
    has_one :seller, Seller
    timestamps()
  end

  def changeset(user, params \\ %{}) do
    user
    |> cast(params, [:username, :password])
    |> validate_required([:username, :password])
    |> unique_constraint(:username)
    |> validate_format(:username, ~r/^\w+$/)
  end
end
