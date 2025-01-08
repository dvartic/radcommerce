defmodule PhoenixDemoWeb.Checkout.CheckoutLive do
  use PhoenixDemoWeb, :live_view

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
      <div id="checkout" phx-hook="InitCheckout" data-checkoutid={@checkout_id}>
        <!-- Checkout will insert the payment form here -->
      </div>
    </div>
    """
  end
end
