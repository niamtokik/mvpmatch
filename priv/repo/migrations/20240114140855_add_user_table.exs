defmodule Mvpmatch.Repo.Migrations.AddUserTable do
  use Ecto.Migration

  def change do
    ######################################################################
    # user table defines an user, using an username and a password.
    ######################################################################
    create table("users") do
      add :username, :string
      add :password, :string, null: false
      timestamps()
    end
    create unique_index("users", :username)

    ######################################################################
    # A buyer is an user with a deposit and can buy products.
    ######################################################################
    create table("buyers") do
      add :user_id, references("users"), null: false
      add :deposit, :integer, default: 0, null: false
      timestamps()
    end
    create unique_index("buyers", :user_id)

    ######################################################################
    # A seller is an user who can sell products.
    ######################################################################
    create table("sellers") do
      add :user_id, references("users"), null: false
      timestamps()
    end
    create unique_index("sellers", :user_id)

    ######################################################################
    # A product is an entry created by a seller defined by an unique
    # name, a positive cost and a positive amount.
    ######################################################################
    create table("products") do
      add :seller_id, references("sellers"), null: false
      add :name, :string, null: false, unique: true
      add :cost, :integer, default: 0, null: false
      add :amount, :integer, default: 0, null: false
      timestamps()
    end
    create unique_index("products", :name)

  end
end
