defmodule PhoenixDemoWeb.Checkout.CheckoutLive do
  use PhoenixDemoWeb, :live_view
  import PhoenixDemoWeb.CustomComponents

  @impl true
  def mount(params, _session, socket) do
    # Read Stripe Checkout ID
    %{"id" => checkout_id} = params

    {:ok,
     socket
     |> assign(:checkout_id, checkout_id)}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <div class="flex flex-col gap-16">
      <h1 class="text-center lg:text-left font-heading text-6xl">
        {gettext("Envío y pago")}
      </h1>
      <%= if is_nil(@current_user) do %>
        <div>
          <p class="mb-4 inline-block font-semibold">{gettext("Si lo deseas, puedes:")}</p>
          <.fast_link
            id="c05d08e9-3747-4f7b-b99c-2194e3cb889b"
            navigate={~p"/users/log_in"}
            class="link link-hover inline-block"
          >
            {gettext("Iniciar sesión")}
          </.fast_link>
          o
          <.fast_link
            id="52a109b3-00b8-4f96-93a8-715bc3524a0a"
            navigate={~p"/users/register"}
            class="link link-hover inline-block"
          >
            {gettext("Registrarte")}
          </.fast_link>
        </div>
      <% end %>
      <div id="checkout" phx-hook="InitCheckout" data-checkoutid={@checkout_id}>
        <!-- Checkout will insert the payment form here -->
      </div>
    </div>
    """
  end
end
