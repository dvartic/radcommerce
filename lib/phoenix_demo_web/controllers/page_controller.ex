defmodule PhoenixDemoWeb.PageController do
  use PhoenixDemoWeb, :controller

  def home(conn, _params) do
    render(conn, :home)
  end
end
