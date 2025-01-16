defmodule PhoenixDemoWeb.User.Orders.Order.OrderLive do
  use PhoenixDemoWeb, :live_view
  import PhoenixDemoWeb.User.Orders.OrderItem
  use Gettext, backend: PhoenixDemoWeb.Gettext
  import PhoenixDemoWeb.User.Orders.Order.OrderProductCard
  alias PhoenixDemo.Orders

  @impl true
  def mount(params, _session, socket) do
    %{"order_number" => order_number} = params

    order =
      Orders.get_order_by_order_number_and_check_user_auth(
        order_number,
        socket.assigns.current_user.id
      )

    {:ok, socket |> assign(order: order)}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <div class="container mx-auto max-w-5xl flex flex-col gap-8">
      <%!-- First row --%>
      <div class="flex flex-row items-center justify-between gap-2">
        <h1 class="text-2xl font-bold">
          {gettext("Pedido")}: # {@order.order_number}
        </h1>
        <div class="badge badge-lg">
          {get_translated_status(@order.status)}
        </div>
      </div>

      <%!-- Second row --%>
      <div class="flex flex-row items-center justify-between gap-2">
        <div>
          <span class="font-semibold">{gettext("Fecha")}:</span>
          <span>
            {if @order.date,
              do:
                Calendar.strftime(@order.date, "%B %-d, %Y %H:%M",
                  month_names: fn month ->
                    {gettext("Enero"), gettext("Febrero"), gettext("Marzo"), gettext("Abril"),
                     gettext("Mayo"), gettext("Junio"), gettext("Julio"), gettext("Agosto"),
                     gettext("Septiembre"), gettext("Octubre"), gettext("Noviembre"),
                     gettext("Diciembre")}
                    |> elem(month - 1)
                  end
                ),
              else: "N/A"}
          </span>
        </div>
        <div>
          <a
            disabled={is_nil(@order.tracking_number) or @order.tracking_number == ""}
            role="button"
            class="btn btn-primary"
            href={
              if is_nil(@order.tracking_number) or @order.tracking_number == "",
                do: "",
                else: "https://parcelsapp.com/en/tracking/" <> @order.tracking_number
            }
            target="_blank"
          >
            {gettext("Seguimiento")}
          </a>
        </div>
      </div>

      <%!-- Third row Products --%>
      <div class="w-full flex flex-col gap-8 border-b pb-6">
        <%= for product <- @order.product_list do %>
          <.order_product_card order_product={product} />
        <% end %>
      </div>

      <%!-- Fourth row Order Summary --%>
      <div class="flex flex-row gap-3 self-end">
        <span class="font-semibold">{gettext("Total")}</span>
        <span>
          €{Decimal.new(@order.total_amount) |> Decimal.div(100) |> Decimal.round(2)}
        </span>
      </div>

      <%!-- Fifth row Order information --%>
      <div class="flex flex-col gap-3">
        <span class="font-bold">{gettext("Información del pedido")}</span>
        <div class="font-semibold text-sm">
          {@order.order_info["shipping_details"]["name"]}
        </div>
        <div class="flex flex-col gap-0.5">
          <%= for {_k, v} <- @order.order_info["shipping_details"]["address"] do %>
            <div class="text-sm italic">{v}</div>
          <% end %>
        </div>
      </div>
    </div>
    """
  end
end
