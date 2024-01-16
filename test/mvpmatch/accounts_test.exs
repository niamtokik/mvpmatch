defmodule Mvpmatch.AccountsTest do
  use ExUnit.Case

  setup do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(Mvpmatch.Repo)
  end

  test "create a new user" do
    :ok
  end
end
