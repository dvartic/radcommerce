defmodule PhoenixDemoWeb.UserForgotPasswordLive do
  use PhoenixDemoWeb, :live_view
  use Gettext, backend: PhoenixDemoWeb.Gettext
  import PhoenixDemoWeb.CustomComponents

  alias PhoenixDemo.Store

  def render(assigns) do
    ~H"""
    <div class="mx-auto max-w-sm">
      <.header class="text-center">
        {gettext("¿Olvidaste tu contraseña?")}
        <:subtitle>
          {gettext("Te enviaremos un enlace para restablecer tu contraseña a tu correo")}
        </:subtitle>
      </.header>

      <.simple_form for={@form} id="reset_password_form" phx-submit="send_email">
        <.input
          field={@form[:email]}
          type="email"
          placeholder={gettext("Correo electrónico")}
          required
          class="input input-bordered"
        />
        <:actions>
          <.button
            id="351f7447-c99a-48e8-9a6b-6179344b5950"
            phx-hook="FormSubmitOnMousedown"
            phx-disable-with={gettext("Enviando...")}
            class="w-full btn btn-primary"
          >
            {gettext("Enviar enlace para restablecer contraseña")}
          </.button>
        </:actions>
      </.simple_form>
      <p class="text-center text-sm mt-4">
        <.fast_link id="c1125fde-aa7c-461d-a806-f70ec567b7c8" href={~p"/users/register"}>
          {gettext("Regístrate")}
        </.fast_link>
        |
        <.fast_link id="5b649f5c-2cc4-41ee-b3f8-a71df6ebb27a" href={~p"/users/log_in"}>
          {gettext("Inicia sesión")}
        </.fast_link>
      </p>
    </div>
    """
  end

  def mount(_params, _session, socket) do
    {:ok, assign(socket, form: to_form(%{}, as: "user"))}
  end

  def handle_event("send_email", %{"user" => %{"email" => email}}, socket) do
    if user = Store.get_user_by_email(email) do
      Store.deliver_user_reset_password_instructions(
        user,
        &url(~p"/users/reset_password/#{&1}")
      )
    end

    info =
      gettext(
        "Si tu email está en nuestro sistema, recibirás instrucciones para restablecer tu contraseña."
      )

    {:noreply,
     socket
     |> put_flash(:info, info)
     |> redirect(to: ~p"/")}
  end
end
