defmodule PhoenixDemoWeb.User.UserOrdersLive do
  use PhoenixDemoWeb, :live_view
  use Gettext, backend: PhoenixDemoWeb.Gettext
  import PhoenixDemoWeb.User.UserMenu
  import PhoenixDemoWeb.User.Orders.OrderItem
  alias PhoenixDemo.Orders

  def mount(_params, _session, socket) do
    user = socket.assigns.current_user

    # If none, will be empty array
    orders = Orders.get_orders_by_user(user.id)

    {:ok, socket |> assign(orders: orders)}
  end

  def render(assigns) do
    ~H"""
    <.user_menu />
    <.header class="max-w-prose mx-auto text-center">
      {gettext("Lista de pedidos")}
    </.header>
    <div class="max-w-5xl mx-auto">
      <%= if length(@orders) == 0 do %>
        <p class="italic">{gettext("No se han encontrado pedidos")}</p>
      <% else %>
        <div class="min-w-full overflow-hidden">
          <div class="grid grid-cols-5 gap-4 bg-gray-100 p-3 font-semibold">
            <div>{gettext("ID")}</div>
            <div>{gettext("Fecha")}</div>
            <div>{gettext("Total")}</div>
            <div>{gettext("Estado")}</div>
            <div>{gettext("Acciones")}</div>
          </div>
          <%= for order <- @orders do %>
            <.order_item order={order} />
          <% end %>
        </div>
      <% end %>
    </div>
    """
  end
end
