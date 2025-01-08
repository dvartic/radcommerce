defmodule PhoenixDemoWeb.Checkout.CheckoutReturnLive do
  use PhoenixDemoWeb, :live_view

  alias PhoenixDemo.Carts
  alias PhoenixDemoWeb.PutCartCookie

  @impl true
  def mount(params, session, socket) do
    # Read Stripe Checkout ID
    %{"id" => checkout_id} = params

    # Cart Id
    cart_id = session[PutCartCookie.cart_id_cookie_name()]

    # Read Stripe result
    stripe_session_res = Stripe.Checkout.Session.retrieve(checkout_id)

    socket =
      case stripe_session_res do
        {:ok, stripe_session} ->
          # Clear cart on success
          Carts.clear_cart(cart_id)

          socket
          |> assign(:checkout_id, checkout_id)
          |> assign(:is_success, true)
          |> assign(:customer_email, stripe_session.customer_details.email)

        {:error, reason} ->
          socket
          |> assign(:checkout_id, checkout_id)
          |> assign(:is_success, false)
          |> assign(
            :stripe_error,
            reason.message
          )
      end

    {:ok, socket}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <div class="flex flex-col gap-16">
      <%= if @is_success == true do %>
        <div role="alert" class="alert alert-success">
          <svg
            xmlns="http://www.w3.org/2000/svg"
            class="h-6 w-6 shrink-0 stroke-current"
            fill="none"
            viewBox="0 0 24 24"
          >
            <path
              stroke-linecap="round"
              stroke-linejoin="round"
              stroke-width="2"
              d="M9 12l2 2 4-4m6 2a9 9 0 11-18 0 9 9 0 0118 0z"
            />
          </svg>
          <span>{gettext("Tu compra se ha realizado con éxito!")}</span>
        </div>
      <% else %>
        <div role="alert" class="alert alert-error">
          <svg
            xmlns="http://www.w3.org/2000/svg"
            class="h-6 w-6 shrink-0 stroke-current"
            fill="none"
            viewBox="0 0 24 24"
          >
            <path
              stroke-linecap="round"
              stroke-linejoin="round"
              stroke-width="2"
              d="M10 14l2-2m0 0l2-2m-2 2l-2-2m2 2l2 2m7-2a9 9 0 11-18 0 9 9 0 0118 0z"
            />
          </svg>
          <span>{gettext("Error! El proceso de pago ha fallado:")} {@stripe_error}</span>
        </div>
      <% end %>

      <div class="w-full flex justify-center">
        <%= if @is_success == true do %>
          <div class="prose text-center">
            <p>
              {gettext("Se ha completado el pago y el pedido se ha realizado con éxito.")}
            </p>
            <p>
              {gettext("Hemos enviado un correo electrónico a")}
              <span class="font-bold">{@customer_email}</span>
              {gettext("con los datos del pedido.")}
            </p>
            <p>
              {gettext("Recibirás un nuevo correo con número de seguimiento.")}
            </p>
          </div>
        <% else %>
          <div class="w-full flex flex-col items-center gap-10">
            <div class="prose text-center">
              <p>
                {gettext(
                  "Por favor, intenta el pago de nuevo. Si el error persiste, contacta con nosotros."
                )}
              </p>
              <p class="text-error">
                {@stripe_error}
              </p>
            </div>
          </div>
        <% end %>
      </div>
    </div>
    """
  end
end
