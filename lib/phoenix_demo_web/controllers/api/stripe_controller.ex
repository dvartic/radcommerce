defmodule PhoenixDemoWeb.Api.StripeController do
  use PhoenixDemoWeb, :controller

  def create(conn, _params) do
    render(conn, :index)
  end
end
