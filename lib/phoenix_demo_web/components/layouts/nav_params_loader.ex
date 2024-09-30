defmodule PhoenixDemoWeb.Layouts.NavParamsLoader do
  import Phoenix.Component

  def on_mount(:default, params, _session, socket) do
    {:cont,
     socket
     |> assign(:params, params)}
  end
end
