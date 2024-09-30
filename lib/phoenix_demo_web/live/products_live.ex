defmodule PhoenixDemoWeb.ProductsLive do
  use PhoenixDemoWeb, :live_view

  # Product Schema
  alias PhoenixDemo.Schemas.Product

  # Module with operations logic
  alias PhoenixDemo.Products

  @impl true
  def mount(_params, _session, socket) do
    product = %Product{}
    changeset = Product.changeset(product)

    socket =
      assign(socket,
        message: "Hello World from assign",
        form: to_form(changeset),
        products: Products.list_products()
      )

    {:ok, socket}
  end

  @impl true
  def handle_event("update", _unsigned_params, socket) do
    socket = assign(socket, message: "UPDATED MESSAGE")

    {:noreply, socket}
  end

  @impl true
  def handle_event("validate", %{"product" => params}, socket) do
    product = %Product{}

    form =
      Product.changeset(product, params)
      |> to_form(action: :validate)

    {:noreply, assign(socket, form: form)}
  end

  @impl true
  def handle_event("save", %{"product" => params}, socket) do
    case Products.create_product(params) do
      {:ok, _product} ->
        {:noreply,
         socket
         |> put_flash(:info, "Product has been created")
         |> push_navigate(to: ~p"/products")}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <%= @message %>
    </div>
    <div>
      <.link phx-click="update">
        Cambia el idioma
      </.link>
    </div>
    <div>
      <.form for={@form} phx-change="validate" phx-submit="save" autocomplete="off">
        <.input type="text" field={@form[:name]} />
        <.button class="flex flex-row gap-1 items-center">
          Save <.icon name="hero-arrow-path" class="h-3 w-3 animate-spin while-submitting" />
        </.button>
      </.form>
    </div>

    <div>
      <%= for product <- @products do %>
        <div>
          <%= product.name %>
        </div>
      <% end %>
    </div>
    """
  end
end
