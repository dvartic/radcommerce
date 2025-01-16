defmodule PhoenixDemoWeb.UserLoginLive do
  use PhoenixDemoWeb, :live_view
  use Gettext, backend: PhoenixDemoWeb.Gettext
  import PhoenixDemoWeb.CustomComponents

  def render(assigns) do
    ~H"""
    <div class="mx-auto max-w-sm">
      <.header class="text-center">
        {gettext("Inicia sesión en tu cuenta")}
        <:subtitle>
          {gettext("No tienes una cuenta?")}
          <.fast_link
            id="edefec15-5a79-4c4e-9c2c-6743016e262e"
            navigate={~p"/users/register"}
            class="font-semibold text-brand hover:underline"
          >
            {gettext("Regístrate")}
          </.fast_link>
          {gettext("ahora.")}
        </:subtitle>
      </.header>

      <.simple_form for={@form} id="login_form" action={~p"/users/log_in"} phx-update="ignore">
        <.input
          field={@form[:email]}
          type="email"
          label={gettext("Correo electrónico")}
          required
          class="input input-bordered"
        />
        <.input
          field={@form[:password]}
          type="password"
          label={gettext("Contraseña")}
          required
          class="input input-bordered"
        />

        <:actions>
          <.input field={@form[:remember_me]} type="checkbox" label={gettext("Mantener sesión")} />
          <.fast_link
            id="48bf2de9-974e-4223-a346-84444fa8fc55"
            href={~p"/users/reset_password"}
            class="text-sm font-semibold"
          >
            {gettext("¿Olvidaste tu contraseña?")}
          </.fast_link>
        </:actions>
        <:actions>
          <.button
            id="c99768d5-d212-4132-81d5-c5a666e056b1"
            phx-hook="FormSubmitOnMousedown"
            phx-disable-with={gettext("Iniciando sesión...")}
            class="w-full btn btn-primary"
          >
            {gettext("Iniciar sesión")} <span aria-hidden="true">→</span>
          </.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  def mount(_params, _session, socket) do
    email = Phoenix.Flash.get(socket.assigns.flash, :email)
    form = to_form(%{"email" => email}, as: "user")
    {:ok, assign(socket, form: form), temporary_assigns: [form: form]}
  end
end
