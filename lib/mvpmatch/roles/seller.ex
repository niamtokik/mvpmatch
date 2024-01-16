defmodule Mvpmatch.Roles.Seller do
  use Ecto.Schema
  import Ecto.Changeset
  alias Mvpmatch.Accounts.User
  alias Mvpmatch.Roles.Product

  schema "sellers" do
    belongs_to :user, User
    has_many :product, Product
    timestamps()
  end

  def changeset(seller, params \\ %{}) do
    seller
    |> cast(params, [:user_id])
    |> unique_constraint(:user_id)
    |> foreign_key_constraint(:user_id)
  end
end
