defmodule PhoenixDemoWeb.User.Orders.OrderItem do
  use Phoenix.Component
  use PhoenixDemoWeb, :verified_routes
  import PhoenixDemoWeb.CustomComponents
  import PhoenixDemoWeb.CoreComponents
  use Gettext, backend: PhoenixDemoWeb.Gettext

  def get_translated_status(status) do
    status_translations = %{
      "processing" => gettext("Procesando"),
      "shipped" => gettext("Enviado"),
      "delivered" => gettext("Entregado"),
      "cancelled" => gettext("Cancelado")
    }

    Map.get(status_translations, status, status)
  end

  attr :order, PhoenixDemo.Schemas.Order, required: true

  def order_item(assigns) do
    ~H"""
    <div class="grid grid-cols-5 gap-4 p-3 border-b">
      <div class="flex flex-row items-center gap-2" x-data="{ truncated: true }">
        <div
          class="font-semibold text-sm truncate"
          x-bind:class="{ 'truncate': truncated, 'break-all': !truncated }"
          title={@order.order_number}
        >
          {@order.order_number}
        </div>
        <button class="btn btn-circle btn-xs btn-outline" x-on:click="truncated = !truncated">
          <.icon name="hero-chevron-up-down" />
        </button>
      </div>
      <div>
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
      </div>
      <div>€{Decimal.new(@order.total_amount) |> Decimal.div(100) |> Decimal.round(2)}</div>
      <div>{get_translated_status(@order.status)}</div>
      <div>
        <.fast_link
          id={@order.order_number}
          navigate={~p"/users/orders/#{@order.order_number}"}
          class="text-blue-600 hover:text-blue-800"
        >
          {gettext("Ver")}
        </.fast_link>
      </div>
    </div>
    """
  end
end
