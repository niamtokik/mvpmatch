defmodule Mvpmatch.Plug.Authenticate do
  @moduledoc ~S"""
  Implementation a Basic Auth and JWT in the same module. The idea is
  to make the old authentication version available in case of problem
  but also switch to JWT smoothly.
  """

  import Plug.Conn
  alias Phoenix.Controller
  alias Mvpmatch.Accounts
  alias Mvpmatch.Accounts.User
  alias Mvpmatch.Token

  def init(opts), do: opts

  def call(conn, _opts) do
    cond do
      jwt_auth?(conn) ->
        jwt_auth_authenticate(conn)
      basic_auth?(conn) ->
        basic_auth_authenticate(conn)
      true ->
        unauthorized(conn)
    end
  end

  # stop the connection and returns unauthorized message.
  defp unauthorized(conn) do
    conn
    |> put_status(:unauthorized)
    |> Controller.json(%{error: :unauthorized})
    |> halt()
  end

  # returns true if a jwt token is present.
  defp jwt_auth?(conn) do
    with {:ok, _} <- jwt_auth_cookie_extractor(conn) do
      true
    else
      _ -> false
    end
  end

  # the field "session" must be present in the jwt session, it will
  # contains user session information.
  defp jwt_auth_cookie_extractor(conn) do
    with %{cookies: cookies} <- fetch_cookies(conn, encrypted: "_mvpmatch_session"),
         {:ok, jwt} <- Map.fetch(cookies, "_mvpmatch_session"),
         {:ok, %{"session" => session}} <- Token.verify_and_validate(jwt) do
      {:ok, session}
    else
      _ -> {:error, "jwt session error"}
    end
  end

  # a jwt session contains only a valid user id.
  defp jwt_auth_authenticate(conn, _params \\ %{}) do
    with {:ok, session} <- jwt_auth_cookie_extractor(conn),
         %{ "username" => _username, "id" => user_id } <- session,
         user = %User{} <- Accounts.get_user(user_id) do
      conn
      |> assign(:user, user)
    else
      _ -> unauthorized(conn)
    end
  end

  # returns true if an authorization header with basic auth is
  # present.
  defp basic_auth?(conn) do
    with ["Basic " <> _] <- get_req_header(conn, "authorization") do
      true
    else
      _ -> false
    end
  end

  # assign an user struct in the connexion in case of success using
  # basic auth.
  defp basic_auth_authenticate(conn, _params \\ %{}) do
    with ["Basic " <> credentials] <- get_req_header(conn, "authorization") do
      case basic_auth_credentials(credentials) do
        user = %User{} ->
          conn
          |> assign(:user, user)
        nil ->
          unauthorized(conn)
      end
    end
  end

  # check the content of basic auth. This function is slow but it has
  # been created to do a simple authentication.
  defp basic_auth_credentials(credentials) do
    with {:ok, decoded} <- Base.decode64(credentials),
         [user, password|_] <- String.split(decoded, ":") do
      Accounts.check_password(user, password)
    else
      _ -> nil
    end
  end
end
