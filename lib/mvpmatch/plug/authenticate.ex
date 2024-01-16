defmodule Mvpmatch.Plug.Authenticate do
  @moduledoc ~S"""
  Implementation a Basic Auth
  """

  import Plug.Conn
  alias Phoenix.Controller
  alias Mvpmatch.Accounts
  alias Mvpmatch.Accounts.User

  def init(opts), do: opts

  def call(conn, _opts) do
    with ["Basic " <> credentials] <- get_req_header(conn, "authorization") do
      case authenticate(credentials) do
        user = %User{} ->
          assign(conn, :user, user)
        nil ->
          conn
          |> put_status(:unauthorized)
          |> Controller.json(%{error: :unauthorized})
          |> halt()
      end
    end
  end

  defp authenticate(credentials) do
    with {:ok, decoded} <- Base.decode64(credentials),
         [user, password|_] <- String.split(decoded, ":") do
      Accounts.check_password(user, password)
    else
      _ -> nil
    end
  end

end
