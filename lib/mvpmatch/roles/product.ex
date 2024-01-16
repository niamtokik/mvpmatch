defmodule Mvpmatch.Roles.Product do
  use Ecto.Schema
  import Ecto.Changeset
  alias Mvpmatch.Roles.Seller

  schema "products" do
    field :name, :string
    field :cost, :integer
    field :amount, :integer
    belongs_to :seller, Seller
    timestamps()
  end

  def changeset(product, params \\ %{}) do
    product
    |> cast(params, [:name, :cost, :amount])
    |> assoc_constraint(:seller)
    |> validate_required([:name, :cost, :amount])
    |> validate_number(:cost, greater_than_or_equal_to: 0)
    |> validate_number(:amount, greater_than_or_equal_to: 0)
    |> unique_constraint([:name])
  end
end
