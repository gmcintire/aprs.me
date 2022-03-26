defmodule AprsWeb.PageController do
  use AprsWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
