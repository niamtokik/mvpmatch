defmodule MvpmatchWeb.Router do
  use MvpmatchWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {MvpmatchWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :api_authenticated do
    plug :accepts, ["json"]
    plug Mvpmatch.Plug.Authenticate
  end

  scope "/", MvpmatchWeb do
    pipe_through :api
    get "/", PageController, :home
    post "/user", UserController, :create
  end

  scope "/", MvpmatchWeb do
    pipe_through :api_authenticated

    ######################################################################
    # Account/Users management
    ######################################################################
    get "/user", UserController, :info

    ######################################################################
    # deposit management (for buyers)
    ######################################################################
    get "/deposit", DepositController, :info
    post "/deposit", DepositController, :add_coins
    post "/reset", DepositController, :reset

    ######################################################################
    # product management (for sellers)
    ######################################################################
    get "/products", ProductController, :list_all
    post "/products", ProductController, :create
    put "/products/:product_id", ProductController, :update
    delete "/products/:product_id", ProductController, :delete

    ######################################################################
    # product management (for buyers)
    ######################################################################
    post "/buy", ProductController, :buy_product

  end

  if Application.compile_env(:mvpmatch, :dev_routes) do
    scope "/dev" do
      pipe_through :browser
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
