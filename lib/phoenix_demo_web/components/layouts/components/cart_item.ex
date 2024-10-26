defmodule PhoenixDemoWeb.Layouts.Components.CartItem do
  use Phoenix.Component
  import PhoenixDemoWeb.CoreComponents
  alias Phoenix.LiveView.JS

  alias PhoenixDemo.Schemas.CartItem
  alias PhoenixDemoWeb.Admin.ProductsLive

  attr :cart_item, CartItem, required: true

  def cart_item_card(assigns) do
    # Image Src
    assigns =
      assign(
        assigns,
        :img_src,
        Map.get(assigns.cart_item.product || %{images: []}, :images)
        |> List.first(nil)
        |> then(fn img_src_or_nil ->
          if img_src_or_nil == nil do
            "/images/image-off.svg"
          else
            ProductsLive.file_url(img_src_or_nil)
          end
        end)
      )

    # Product Name
    assigns =
      assign(assigns, :product_name, Map.get(assigns.cart_item.product || %{name: "N/A"}, :name))

    # Product Price
    assigns =
      assign(
        assigns,
        :product_price,
        Map.get(assigns.cart_item.product || %{price: "N/A"}, :price)
      )

    # Product properties
    properties_parsed =
      if assigns.cart_item.properties == nil do
        nil
      else
        with {:ok, value} <- Jason.decode(assigns.cart_item.properties) do
          Map.values(value)
        else
          {:error, _reason} -> nil
        end
      end

    # Properties parsed are a list of values of the properties eg Silver, XS, etc
    assigns = assign(assigns, :properties_parsed, properties_parsed)

    ~H"""
    <div class="flex flex-row gap-3 justify-between items-stretch h-20 sm:h-24">
      <%!-- IMAGE --%>
      <figure class="relative">
        <img
          src={@img_src}
          alt={@product_name}
          class="min-w-20 w-20 sm:min-w-24 sm:w-24 h-full object-contain bg-base-100 rounded-lg shadow"
        />
      </figure>
      <%!-- NAME AND PRICE --%>
      <div class="flex flex-col gap-2 flex-grow h-full items-start justify-between">
        <div class="flex flex-col gap-1">
          <p class="font-bold text-sm sm:text-md leading-4 sm:leading-5 line-clamp-2">
            <%= @product_name %>
          </p>

          <%= if @properties_parsed != nil do %>
            <div class="flex flex-row max-h-[16px] overflow-hidden flex-wrap gap-1">
              <%= for value <- @properties_parsed do %>
                <div class="badge badge-primary badge-xs sm:badge-sm"><%= value %></div>
              <% end %>
            </div>
          <% end %>
        </div>
        <div class="font-mono font-medium text-sm sm:text-md"><%= @product_price %></div>
      </div>
      <%!-- QUANTITY AND REMOVE --%>
      <div class="h-full flex flex-col items-end justify-between gap-2">
        <button
          class="btn btn-square btn-xs phx-submit-loading:opacity-75"
          qphx-mousedown={JS.push("delete_item")}
          phx-value-itemid={@cart_item.id}
        >
          <.icon name="hero-trash" class="h-3 w-3" />
        </button>
        <div class="flex flex-row items-center gap-2">
          <button
            class="btn btn-square btn-xs phx-submit-loading:opacity-75"
            qphx-mousedown={JS.push("decrease_quantity")}
            phx-value-itemid={@cart_item.id}
          >
            <.icon name="hero-minus" class="h-3 w-3" />
          </button>
          <input
            type="text"
            inputmode="numeric"
            pattern="[0-9]*"
            class="rounded-md bg-base-300 w-6 px-1 text-center"
            maxlength="2"
            value={@cart_item.quantity}
            phx-value-itemid={@cart_item.id}
            phx-blur={JS.push("set_quantity")}
          />
          <button
            class="btn btn-square btn-xs phx-submit-loading:opacity-75"
            qphx-mousedown={JS.push("increase_quantity")}
            phx-value-itemid={@cart_item.id}
          >
            <.icon name="hero-plus" class="h-3 w-3" />
          </button>
        </div>
      </div>
    </div>
    """
  end
end
