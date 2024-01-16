defmodule Mvpmatch.Roles.Buyer do
  use Ecto.Schema
  import Ecto.Changeset
  alias Mvpmatch.Accounts.User

  schema "buyers" do
    field :deposit, :integer
    belongs_to :user, User
    timestamps()
  end

  def changeset(buyer, params \\ %{}) do
    buyer
    |> cast(params, [:deposit, :user_id])
    |> foreign_key_constraint(:user_id)
    |> validate_required(:user_id)
    |> unique_constraint(:user_id)
    |> validate_number(:deposit, greater_than_or_equal_to: 0)
  end
end
