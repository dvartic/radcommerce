defmodule PhoenixDemoWeb.CannonicalHost do
  import Plug.Conn
  alias Plug.Conn
  import Phoenix.Controller, only: [redirect: 2]

  @forwarded_port_header "x-forwarded-port"
  @forwarded_proto_header "x-forwarded-proto"

  def init(_) do
    %{}
  end

  def call(conn, _opts) do
    request_host = conn.host
    canonical_host = Application.get_env(:phoenix_demo, PhoenixDemoWeb.Endpoint)[:url][:host]

    if request_host == "www." <> canonical_host do
      conn
      |> put_status(:moved_permanently)
      |> redirect(external: redirect_location(conn, canonical_host))
      |> halt()
    else
      conn
    end
  end

  defp redirect_location(conn, canonical_host) do
    conn
    |> request_uri
    |> URI.parse()
    |> sanitize_empty_query()
    |> Map.put(:host, canonical_host)
    |> URI.to_string()
  end

  @spec request_uri(%Conn{}) :: String.t()
  defp request_uri(
         conn = %Conn{host: host, request_path: request_path, query_string: query_string}
       ) do
    "#{canonical_scheme(conn)}://#{host}:#{canonical_port(conn)}#{request_path}?#{query_string}"
  end

  defp canonical_port(conn = %Conn{port: port}) do
    case {get_req_header(conn, @forwarded_port_header),
          get_req_header(conn, @forwarded_proto_header)} do
      {[forwarded_port], _} -> forwarded_port
      {[], ["http"]} -> 80
      {[], ["https"]} -> 443
      {[], []} -> port
    end
  end

  defp canonical_scheme(conn = %Conn{scheme: scheme}) do
    case get_req_header(conn, @forwarded_proto_header) do
      [forwarded_proto] -> forwarded_proto
      [] -> scheme
    end
  end

  defp sanitize_empty_query(uri = %URI{query: ""}), do: Map.put(uri, :query, nil)
  defp sanitize_empty_query(uri), do: uri
end
