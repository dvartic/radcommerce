defmodule PhoenixDemoWeb.PutDomain do
  import Plug.Conn

  def init(_) do
    %{}
  end

  def call(conn, _opts) do
    conn
    # For Liveview
    |> put_session(:domain, "#{conn.scheme}://#{conn.host}:#{conn.port}")

    # For standard controller
    |> assign(:domain, "#{conn.scheme}://#{conn.host}:#{conn.port}")
  end
end
