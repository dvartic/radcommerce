defmodule PhoenixDemoWeb.Products.ProductsLive do
  use PhoenixDemoWeb, :live_view

  # Module with operations logic
  alias PhoenixDemo.Products
  alias PhoenixDemo.Categories

  # Custom components
  import PhoenixDemoWeb.Products.ProductCard
  import PhoenixDemoWeb.Products.CategoriesPanel

  @impl true
  def mount(_params, _session, socket) do
    # Pre-render item list
    product_list = Products.list_products()
    product_categories = Categories.list_categories()

    {:ok,
     socket
     |> assign(products: product_list)
     |> assign(categories: product_categories)
     |> assign(selected_cat_id: nil)}
  end

  @impl true
  def handle_params(%{"q" => search_query}, _uri, socket) do
    # Perform search based on query, and return new list of items
    socket = assign(socket, products: Products.search_products(search_query))
    {:noreply, socket}
  end

  @impl true
  def handle_params(%{"cat" => category_id}, _uri, socket) do
    # Filter products by category

    parsed_id =
      case Integer.parse(category_id) do
        {id, ""} -> id
        _ -> nil
      end

    {:noreply,
     socket
     |> assign(selected_cat_id: parsed_id)
     |> then(fn socket ->
       case parsed_id do
         nil -> socket
         id -> assign(socket, :products, Products.list_products_by_cat(id))
       end
     end)}
  end

  @impl true
  def handle_params(_unsigned_params, _uri, socket) do
    {:noreply, socket}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <section class="flex flex-col sm:flex-row gap-10">
      <.product_categories categories={@categories} selected_cat_id={@selected_cat_id} />
      <div class="grid grid-flow-row gap-8 grid-cols-1 sm:grid-cols-2 md:grid-cols-3 lg:grid-cols-3 xl:grid-cols-4">
        <%= for product <- @products do %>
          <.product_card product={product} />
        <% end %>
      </div>
    </section>
    """
  end
end
