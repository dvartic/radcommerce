defmodule PhoenixDemoWeb.PutCartCookie do
  @moduledoc """
  Reads a cart id cookie, creates a cart in case it does not exist and puts it into session
  """

  import Plug.Conn
  alias PhoenixDemo.Carts

  def cart_id_cookie_name(), do: "cart_id"

  def init(_) do
    %{}
  end

  def call(conn, _opts) do
    conn = fetch_cookies(conn, encrypted: ~w(#{cart_id_cookie_name()}))
    # String or nil
    cookie = conn.cookies[cart_id_cookie_name()]

    {conn, cart_id} =
      case cookie do
        nil ->
          # Create cart
          {:ok, cart_struct} = Carts.create_cart(%{})
          # Place cart id on cookie
          new_cart_id = cart_struct.id

          conn =
            put_resp_cookie(conn, cart_id_cookie_name(), new_cart_id,
              encrypt: true,
              max_age: 31_556_952
            )

          {conn, new_cart_id}

        _ ->
          {conn, cookie}
      end

    conn
    # For Liveview
    |> put_session(:cart_id, cart_id)

    # For standard controller
    |> assign(:cart_id, cart_id)
  end
end
