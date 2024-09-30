defmodule PhoenixDemoWeb.HomeProductShowcase.ProductShowcase do
  use Phoenix.Component

  import PhoenixDemoWeb.Products.ProductCard

  attr :products, :list, required: true

  def product_showcase(assigns) do
    ~H"""
    <section class="w-[100%] max-w-[100%] overflow-auto flex flex-row gap-6 py-10 px-2">
      <%= for product <- @products do %>
        <div class="min-w-80">
          <.product_card product={product} />
        </div>
      <% end %>
    </section>
    """
  end
end
