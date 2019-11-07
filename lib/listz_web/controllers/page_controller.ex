defmodule ListzWeb.PageController do
  use ListzWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
