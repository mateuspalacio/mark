defmodule MarkWeb.PageController do
  use MarkWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
