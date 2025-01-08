defmodule PhoenixDemoWeb.HomeLive do
  use PhoenixDemoWeb, :live_view

  alias PhoenixDemo.Products

  import PhoenixDemoWeb.HomeProductShowcase.ProductShowcase

  import PhoenixDemoWeb.Home.AdvantagesCards

  import PhoenixDemoWeb.CustomComponents

  use Gettext, backend: PhoenixDemoWeb.Gettext

  @impl true
  def mount(_params, session, socket) do
    locale = Map.get(session, :locale, "es")

    # Fetch random sample of products
    random_products = Products.get_random_sample_products(5)

    socket =
      socket
      |> assign(:locale, locale)
      |> assign(:random_products, random_products)

    {:ok, socket}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <div class="flex flex-col gap-48">
      <div class="absolute w-[100vw] min-h-[64px] bg-green-800 left-0 top-[73px] py-2">
        <div
          id="cycle-advtanges-cont"
          phx-hook="CycleAdvantages"
          class="w-full max-w-4xl mx-auto px-4 sm:px-6 lg:px-8 flex items-center justify-center sm:justify-between"
        >
          <%!-- FREE SHIPPING --%>
          <div class="flex flex-col items-center justify-center transition-all duration-150">
            <p class="text-white font-bold uppercase font-heading text-xl tracking-widest">
              {gettext("Envío Gratis")}
            </p>
            <p class="text-white text-sm">{gettext("A toda Europa")}</p>
          </div>

          <%!-- FIVE STAR RATING --%>
          <div class="flex flex-col items-center justify-center transition-all duration-150">
            <p class="text-white font-bold uppercase font-heading text-xl tracking-widest">
              {gettext("⋆⋆⋆⋆⋆")}
            </p>
            <a
              class="link link-hover text-white text-sm"
              href="https://www.ebay.es/usr/acg_micro"
              target="_blank"
            >
              {gettext("100% votos positivos")}
            </a>
          </div>

          <%!-- VOLUMEN DE VENTAS --%>
          <div class="flex flex-col items-center justify-center transition-all duration-150">
            <p class="text-white font-bold uppercase font-heading text-xl tracking-widest">
              {gettext("Experiencia")}
            </p>
            <p class="text-white text-sm" href="https://www.ebay.es/usr/acg_micro" target="_blank">
              {gettext(">1.2 mil artículos vendidos")}
            </p>
          </div>
        </div>
      </div>

      <%!-- HERO --%>
      <section class="w-full flex flex-col lg:flex-row items-center lg:items-end justify-start lg:justify-between gap-16">
        <div class="w-full max-w-[480px] lg:w-[40%] lg:max-w-[40%] flex flex-col gap-6 items-center lg:items-start flex-grow flex-shrink">
          <h1 class="text-center lg:text-left font-heading text-5xl" phx-no-format><%= gettext("Piezas y componentes de electrónica.") %> <span class="bg-primary py-0 px-3 rounded-full text-black"><%= gettext("Especializados") %></span> <%= gettext("en Apple.") %></h1>
          <p class="text-lg text-center lg:text-left">
            {gettext(
              "Miles de componentes vendidos. Envío gratuíto a Europa. Soporte rápido experto en Apple."
            )}
          </p>
          <div class="flex flex-row gap-4">
            <.fast_link class="btn btn-primary" navigate={~p"/products"} id="prod-link-hero">
              {gettext("Ver Productos")}
            </.fast_link>
          </div>
        </div>

        <figure class="relative w-full lg:w-[60%] max-w-[600px] flex-grow-0 flex-shrink-0">
          <img
            src={~p"/images/macbook-repair.avif"}
            alt={gettext("Hero image")}
            class="w-full object-contain rounded-lg"
            width="800"
            height="533"
          />
        </figure>
      </section>

      <%!-- PRODUCT SHOWCASE --%>
      <.product_showcase products={@random_products} locale={@locale} />

      <%!-- BENEFITS --%>
      <section class="w-full flex flex-col items-center gap-12">
        <h2 class="text-3xl font-bold">{gettext("Por qué elegirnos")}</h2>
        <div class="w-full flex flex-row items-center flex-wrap justify-center gap-12">
          <.advantages_card>
            <:title>
              <div class="flex flex-col gap-2 items-center">
                <img
                  src={~p"/images/return-box.svg"}
                  alt={gettext("Return policy")}
                  class="w-20 h-20"
                  width="80"
                  height="80"
                />
                <p class="text-2xl font-bold">{gettext("Devoluciones")}</p>
              </div>
            </:title>
            <:description>
              <div class="prose">
                <ul>
                  <li>{gettext("Devoluciones gratuitas 30 días.")}</li>
                  <li>
                    {gettext("Recogidas directas en dirección o depósito en punto de entrega.")}
                  </li>
                  <li>{gettext("Inicia el proceso poniéndote en contacto con nosotros.")}</li>
                </ul>
              </div>
            </:description>
          </.advantages_card>

          <.advantages_card>
            <:title>
              <div class="flex flex-col gap-2 items-center">
                <img
                  src={~p"/images/shipping.svg"}
                  alt={gettext("Shipping policy")}
                  class="w-20 h-20"
                  width="80"
                  height="80"
                />
                <p class="text-2xl font-bold">{gettext("Envíos")}</p>
              </div>
            </:title>
            <:description>
              <div class="prose">
                <ul>
                  <li>{gettext("Envío gratuíto en todos los productos.")}</li>
                  <li>{gettext("Servicio 24hrs península y 48/72hrs islas.")}</li>
                  <li>{gettext("Servicio estándar y express a Europa.")}</li>
                  <li>
                    {gettext("Se envía el mismo día si se compra antes de las 13:00h hora EET.")}
                  </li>
                </ul>
              </div>
            </:description>
          </.advantages_card>
          <.advantages_card>
            <:title>
              <div class="flex flex-col gap-2 items-center">
                <.icon name="hero-envelope" class="w-20 h-20" />
                <p class="text-2xl font-bold">{gettext("Soporte")}</p>
              </div>
            </:title>
            <:description>
              <div class="prose">
                <ul>
                  <li>
                    {gettext(
                      "Contacta con nosotros si tienes alguna duda o problema con el pedido. Responderemos lo antes posible en menos de 24hrs."
                    )}
                  </li>
                  <li>
                    {gettext("Trabajaremos con diligencia para resolver cualquier problema.")}
                  </li>
                </ul>
              </div>
            </:description>
          </.advantages_card>
        </div>
      </section>
    </div>
    """
  end
end
