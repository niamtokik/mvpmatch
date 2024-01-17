defmodule MvpmatchWeb.PageController do
  use MvpmatchWeb, :controller

  def home(conn, _params) do
    render(conn, :home, layout: false)
  end
end
