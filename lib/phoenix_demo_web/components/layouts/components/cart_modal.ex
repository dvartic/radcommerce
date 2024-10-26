defmodule PhoenixDemoWeb.Layouts.Components.CartModal do
  use PhoenixDemoWeb, :live_view

  on_mount PhoenixDemoWeb.RestoreLocale

  import PhoenixDemoWeb.CustomComponents

  alias PhoenixDemo.Carts

  alias PhoenixDemoWeb.PutCartCookie

  import PhoenixDemoWeb.Layouts.Components.CartItem

  alias PhoenixDemoWeb.Admin.ProductsLive

  import PhoenixDemoWeb.Layouts.Components.ShippingAllowedCountries

  @impl true
  def mount(_params, session, socket) do
    cart_id = session[PutCartCookie.cart_id_cookie_name()]
    domain = session["domain"]

    # Subscribe to cart channel
    PhoenixDemoWeb.Endpoint.subscribe("cart:" <> Integer.to_string(cart_id))

    # Load cart
    cart = Carts.get_cart_with_products(cart_id)

    {:ok,
     socket
     |> assign(cart: cart)
     |> assign(stripe_error: nil)
     |> assign(:is_loading, false)
     |> assign(:domain, domain)}
  end

  @impl true
  @spec handle_event(<<_::64, _::_*8>>, nil | maybe_improper_list() | map(), atom() | map()) ::
          {:noreply, atom() | map()}
  def handle_event("delete_item", params, socket) do
    cart_item_id = params["itemid"]
    deleted_cart_item = Carts.delete_cart_item_id(cart_item_id)

    # Remove deleted item from socket
    Enum.filter(socket.assigns.cart.items || [], fn el ->
      el.id != deleted_cart_item.id
    end)

    socket =
      update(socket, :cart, fn cart ->
        new_cart_items =
          Enum.filter(cart.items || [], fn el ->
            el.id != deleted_cart_item.id
          end)

        Map.put(cart, :items, new_cart_items)
      end)

    {:noreply, socket}
  end

  @impl true
  def handle_event("set_quantity", params, socket) do
    cart_item_id = params["itemid"]
    quantity = params["value"]

    new_cart_item = Carts.update_cart_item_quantity(cart_item_id, quantity)

    # Update
    socket =
      update(socket, :cart, fn cart ->
        new_cart_items =
          Enum.map(cart.items || [], fn el ->
            if el.id == new_cart_item.id do
              new_cart_item
            else
              el
            end
          end)

        %{cart | :items => new_cart_items}
      end)

    {:noreply, socket}
  end

  @impl true
  def handle_event("increase_quantity", params, socket) do
    cart_item_id = String.to_integer(params["itemid"])

    current_quantity = get_current_quantity(socket, cart_item_id)

    # Disallow more than 99
    if current_quantity == 99 do
      # Do nothing
      {:noreply, socket}
    else
      socket = update_socket_and_modify_quantity(socket, cart_item_id, current_quantity + 1)
      {:noreply, socket}
    end
  end

  @impl true
  def handle_event("decrease_quantity", params, socket) do
    cart_item_id = String.to_integer(params["itemid"])

    current_quantity = get_current_quantity(socket, cart_item_id)

    # Disallow less than 1
    if current_quantity == 1 do
      # Do nothing
      {:noreply, socket}
    else
      socket = update_socket_and_modify_quantity(socket, cart_item_id, current_quantity - 1)
      {:noreply, socket}
    end
  end

  @impl true
  def handle_event("checkout", _params, socket) do
    # Read cart from socket
    cart = socket.assigns.cart

    # Asynchrnously handle stripe checkout
    send(self(), {:run_checkout, cart})

    # Set loading state
    {:noreply, assign(socket, :is_loading, true)}
  end

  @impl true
  def handle_info({:run_checkout, cart}, socket) do
    domain = socket.assigns.domain

    # Read i18n
    current_locale = Gettext.get_locale(PhoenixDemoWeb.Gettext)

    # Create checkout session
    session_res =
      Stripe.Checkout.Session.create(%{
        ui_mode: :embedded,
        line_items:
          Enum.map(cart.items, fn cart_item ->
            %{
              quantity: cart_item.quantity,
              price_data: %{
                currency: "eur",
                unit_amount: cart_item.product.price.amount,
                product_data: %{
                  name: cart_item.product.name,
                  description: cart_item.product.description,
                  metadata: Jason.decode!(cart_item.properties),
                  images:
                    Map.get(cart_item.product || %{images: []}, :images)
                    |> Enum.map(fn image ->
                      if image == nil do
                        "/images/image-off.svg"
                      else
                        ProductsLive.file_url(image)
                      end
                    end)
                }
              }
            }
          end),
        return_url: "#{domain}/checkout-return/{CHECKOUT_SESSION_ID}",
        mode: :payment,
        shipping_address_collection: %{
          allowed_countries: get_allowed_countries()
        },
        custom_text: %{
          shipping_address: %{message: gettext("Envío express o estándar desde España")}
        },
        locale: String.to_atom(current_locale),
        phone_number_collection: %{enabled: true}
      })

    case session_res do
      {:ok, session} ->
        {:noreply,
         socket
         |> assign(:is_loading, false)
         |> push_navigate(to: "/checkout/#{session.client_secret}")}

      {:error, reason} ->
        {:noreply,
         socket
         |> assign(:stripe_error, "Failed to connect to payment processor: #{reason.message}")
         |> assign(:is_loading, false)}
    end
  end

  @impl true
  def handle_info(msg, socket) do
    {:noreply, assign(socket, cart: msg.payload.cart)}
  end

  def get_current_quantity(socket, cart_item_id) do
    # Find current cart_item
    current_cart_item =
      Enum.find(socket.assigns.cart.items, fn item -> item.id == cart_item_id end)

    current_cart_item.quantity
  end

  def update_socket_and_modify_quantity(socket, cart_item_id, new_quantity) do
    new_cart_item = Carts.update_cart_item_quantity(cart_item_id, new_quantity)
    # Update
    update(socket, :cart, fn cart ->
      new_cart_items =
        Enum.map(cart.items || [], fn el ->
          if el.id == new_cart_item.id do
            new_cart_item
          else
            el
          end
        end)

      %{cart | :items => new_cart_items}
    end)
  end

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.drawer id="confirm-modal" containerClass="w-[100vw] max-w-xl">
        <div class="h-full flex flex-col gap-6 sm:gap-10">
          <h1 class="font-bold text-xl"><%= gettext("Carrito") %></h1>
          <%!-- CART ITEMS --%>
          <div class="max-h-full h-full overflow-auto flex flex-col gap-6 sm:gap-10 px-2">
            <%= for cart_item <- @cart.items do %>
              <.cart_item_card cart_item={cart_item} />
            <% end %>
          </div>

          <%!-- CART ACTIONS --%>
          <div class="flex flex-col gap-1">
            <%= if @stripe_error != nil do %>
              <p class="text-xs text-error">
                <%= @stripe_error %>
              </p>
            <% end %>
            <button
              type="button"
              class="btn btn-block btn-primary btn-lg"
              qphx-mousedown={JS.push("checkout")}
              disabled={@cart.items == [] || @is_loading}
              aria-label="Open cart and proceed to checkout"
            >
              <%= if @is_loading == true do %>
                <svg
                  class="animate-spin h-6 w-6 text-white"
                  xmlns="http://www.w3.org/2000/svg"
                  fill="none"
                  viewBox="0 0 24 24"
                >
                  <circle
                    class="opacity-25"
                    cx="12"
                    cy="12"
                    r="10"
                    stroke="currentColor"
                    stroke-width="4"
                  >
                  </circle>
                  <path
                    class="opacity-75"
                    fill="currentColor"
                    d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z"
                  >
                  </path>
                </svg>
              <% else %>
                <.icon name="hero-shopping-bag" class="h-6 w-6" />
              <% end %>
              <%= gettext("Realizar Compra") %>
            </button>
          </div>
        </div>
      </.drawer>
      <.button
        qphx-mousedown={show_drawer(:right, "confirm-modal")}
        class="btn btn-square btn-primary rounded-md btn-md"
      >
        <.icon name="hero-shopping-cart-solid" class="h-4 w-4" />
      </.button>
    </div>
    """
  end
end
