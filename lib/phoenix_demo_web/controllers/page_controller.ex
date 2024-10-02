defmodule PhoenixDemoWeb.PageController do
  use PhoenixDemoWeb, :controller

  plug :put_layout, false

  def health_check(conn, _params) do
    render(conn, :home)
  end
end
