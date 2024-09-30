defmodule PhoenixDemoWeb.Products.Product.ProductLive do
  use PhoenixDemoWeb, :live_view

  # Module with operations logic
  alias PhoenixDemo.Products
  alias PhoenixDemo.Carts

  # Cart Cookie Plug
  alias PhoenixDemoWeb.PutCartCookie

  # Custom components
  import PhoenixDemoWeb.Products.Product.ProductView

  defp get_types(properties) do
    if properties == nil do
      nil
    else
      with {:ok, value} <- Jason.decode(properties) do
        value
      else
        {:error, _reason} -> nil
      end
    end
  end

  @impl true
  def mount(params, session, socket) do
    # Read product info from params
    %{"id" => product_id} = params
    product = Products.get_product(product_id)
    socket = assign(socket, product: product)

    # Load cart
    cart_id = session[PutCartCookie.cart_id_cookie_name()]
    cart = Carts.get_cart(cart_id)
    socket = assign(socket, cart: cart)

    # Custom Cart Item Form
    types = get_types(product.properties)

    types_map =
      if types == nil do
        %{}
      else
        Map.keys(types)
        |> Map.from_keys(:string)
      end

    socket = assign(socket, form: to_form(types_map))

    {:ok, socket}
  end

  @impl true
  def handle_event("validate", _values, socket) do
    {:noreply, socket}
  end

  @impl true
  def handle_event("save", values, socket) do
    # Validate that all keys present and value
    product = socket.assigns.product
    cart = socket.assigns.cart
    cart_id = cart.id
    product_id = product.id
    types = get_types(product.properties)

    valid? =
      if types == nil do
        true
      else
        Map.keys(types)
        |> Enum.all?(&Map.has_key?(values, &1))
      end

    if valid? == true do
      # Save
      properties_enc = Jason.encode!(values)
      new_cart = Carts.add_to_cart(cart_id, product_id, properties_enc)

      PhoenixDemoWeb.Endpoint.broadcast_from(
        self(),
        "cart:" <> Integer.to_string(cart_id),
        "add_to_cart",
        %{
          cart: new_cart
        }
      )

      {:noreply,
       socket
       |> push_event("js-exec", %{
         to: "#confirm-modal",
         attr: "data-show-drawer"
       })}
    else
      # Do nothing and return an error
      {:noreply,
       socket
       |> assign(
         form:
           to_form(values, errors: [global: {"Se debe seleccionar una opción por apartado", []}])
       )}
    end
  end

  @impl true
  def render(assigns) do
    ~H"""
    <section class="flex flex-col gap-16">
      <.product_view product={@product} form={@form} />
    </section>
    """
  end
end
