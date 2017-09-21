defmodule ExApiWeb.PageController do
  use ExApiWeb, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
