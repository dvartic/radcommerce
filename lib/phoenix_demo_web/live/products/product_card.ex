defmodule PhoenixDemoWeb.Products.ProductCard do
  use Phoenix.Component
  use PhoenixDemoWeb, :verified_routes

  # Product Schema
  alias PhoenixDemo.Schemas.Product

  alias PhoenixDemoWeb.Admin.ProductsLive

  attr :product, Product, required: true

  def product_card(assigns) do
    # Image Src
    assigns =
      assign(
        assigns,
        :img_src,
        assigns.product.images
        |> List.first(nil)
        |> then(fn img_src_or_nil ->
          if img_src_or_nil == nil do
            "/images/image-off.svg"
          else
            ProductsLive.file_url(img_src_or_nil)
          end
        end)
      )

    ~H"""
    <div class="card bg-base-100 w-full shadow-xl hover:shadow-yellow-500/20">
      <figure class="relative">
        <img src={@img_src} alt={@product.name} class="w-full h-48 object-contain bg-slate-50" />
      </figure>

      <.link class="absolute w-full h-full z-10" navigate={~p"/products/#{@product.id}"}></.link>

      <div class="card-body">
        <h2 class="card-title line-clamp-3 min-h-[5.25rem]"><%= @product.name %></h2>
        <div class="card-actions flex flex-row justify-between items-center mt-4 relative z-20">
          <div class="font-mono font-medium text-lg"><%= @product.price %></div>
        </div>
      </div>
    </div>
    """
  end
end
