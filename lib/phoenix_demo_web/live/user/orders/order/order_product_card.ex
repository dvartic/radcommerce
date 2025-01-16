defmodule PhoenixDemoWeb.User.Orders.Order.OrderProductCard do
  use Phoenix.Component
  import PhoenixDemoWeb.Utils.Utils
  import PhoenixDemoWeb.CustomComponents

  attr :order_product, :any, required: true

  def order_product_card(assigns) do
    assigns =
      assigns
      |> assign(:img_src, resolve_img_src_full_path(assigns.order_product["images"]))

    ~H"""
    <div class="flex flex-row items-center justify-between gap-4 border-t pt-6">
      <div class="flex flex-row items-start gap-2">
        <figure class="relative">
          <img
            src={@img_src}
            alt={@order_product["name"]}
            class="w-full h-28 object-contain bg-slate-50"
          />
        </figure>
        <div class="flex flex-col gap-2">
          <.fast_link
            id="0aa99ef1-4cc9-407b-a02b-f95c5c1a6537"
            class="link link-hover text-lg font-semibold"
            navigate={@order_product["original_url"]}
          >
            {@order_product["name"]}
          </.fast_link>
          <div class="text-md text-base-content  italic">
            {if @order_product["properties"],
              do:
                @order_product["properties"]
                |> Enum.map(fn {k, v} -> "#{k}: #{v}" end)
                |> Enum.join(", "),
              else: ""}
          </div>
        </div>
      </div>

      <div class="flex flex-row gap-6">
        <div class="text-md font-semibold">
          {if @order_product["unit_amount"],
            do:
              "€" <>
                (Decimal.new(@order_product["unit_amount"])
                 |> Decimal.div(100)
                 |> Decimal.round(2)
                 |> Decimal.to_string()),
            else: ""}
        </div>
        <div class="text-md">
          {if @order_product["quantity"],
            do: "x" <> (@order_product["quantity"] |> Integer.to_string()),
            else: ""}
        </div>
        <div class="text-md font-semibold">
          €{Decimal.new(@order_product["price"]) |> Decimal.div(100) |> Decimal.round(2)}
        </div>
      </div>
    </div>
    """
  end
end
