defmodule PhoenixDemoWeb.HomeLive do
  use PhoenixDemoWeb, :live_view

  alias PhoenixDemo.Products

  import PhoenixDemoWeb.HomeProductShowcase.ProductShowcase

  @impl true
  def mount(_params, _session, socket) do
    # Fetch random sample of products
    random_products = Products.get_random_sample_products(10)

    socket = assign(socket, :random_products, random_products)

    {:ok, socket}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <div class="flex flex-col gap-32">
      <%!-- HERO --%>
      <section class="w-full flex flex-col lg:flex-row items-center lg:items-end justify-start lg:justify-between gap-16">
        <div class="w-full max-w-[480px] lg:w-[40%] lg:max-w-[40%] flex flex-col gap-6 items-center lg:items-start flex-grow flex-shrink">
          <h1 class="text-center lg:text-left font-heading text-5xl" phx-no-format>Piezas y componentes de electrónica. <span class="bg-primary py-0 px-3 rounded-full text-black">Especializados</span> en Apple.</h1>
          <p class="text-lg text-center lg:text-left">
            Miles de componentes vendidos. Envío gratuíto a Europa. Soporte rápido experto en Apple.
          </p>
          <div class="flex flex-row gap-4">
            <.link class="btn btn-primary" navigate={~p"/products"}>
              Ver Productos
            </.link>
            <.link class="btn btn-outline" navigate={~p"/about"}>
              Información
            </.link>
          </div>
        </div>

        <figure class="relative w-full lg:w-[60%] max-w-[600px] flex-grow-0 flex-shrink-0">
          <img
            src={~p"/images/macbook-repair.jpg"}
            alt="Hero image"
            class="w-full object-contain rounded-lg"
          />
        </figure>
      </section>

      <%!-- PRODUCT SHOWCASE --%>
      <.product_showcase products={@random_products} />
    </div>
    """
  end
end
