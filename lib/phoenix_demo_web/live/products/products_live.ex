defmodule PhoenixDemoWeb.Products.ProductsLive do
  use PhoenixDemoWeb, :live_view

  # Module with operations logic
  alias PhoenixDemo.Products

  # Custom components
  import PhoenixDemoWeb.Products.ProductCard

  @impl true
  def mount(_params, _session, socket) do
    # Pre-render item list
    socket = assign(socket, products: Products.list_products())

    {:ok, socket}
  end

  @impl true
  def handle_params(%{"q" => search_query}, _uri, socket) do
    # Perform search based on query, and return new list of items
    socket = assign(socket, products: Products.search_products(search_query))
    {:noreply, socket}
  end

  @impl true
  def handle_params(_unsigned_params, _uri, socket) do
    {:noreply, socket}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <section>
      <div class="grid grid-flow-row gap-8 grid-cols-1 sm:grid-cols-2 md:grid-cols-3 lg:grid-cols-3 xl:grid-cols-4">
        <%= for product <- @products do %>
          <.product_card product={product} />
        <% end %>
      </div>
    </section>
    """
  end
end
