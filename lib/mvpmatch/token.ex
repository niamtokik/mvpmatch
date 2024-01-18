defmodule Mvpmatch.Token do
  use Joken.Config
  alias Mvpmatch.Accounts.User

  def create_user_session(user = %User{}) do
    %{
      "session" => %{
        "username" => user.username,
        "id" => user.id
      }
    }
    |> generate_and_sign()
  end
end
