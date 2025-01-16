defmodule PhoenixDemoWeb.UserRegistrationLive do
  use PhoenixDemoWeb, :live_view
  use Gettext, backend: PhoenixDemoWeb.Gettext

  import PhoenixDemoWeb.CustomComponents

  alias PhoenixDemo.Store
  alias PhoenixDemo.Store.User

  def render(assigns) do
    ~H"""
    <div class="mx-auto max-w-sm">
      <.header class="text-center">
        {gettext("Regístrate")}
        <:subtitle>
          {gettext("¿Ya tienes una cuenta?")}
          <.fast_link
            id="f0540775-a631-4f67-a9e0-5ad81cd45992"
            navigate={~p"/users/log_in"}
            class="font-semibold text-brand hover:underline"
          >
            {gettext("Inicia sesión")}
          </.fast_link>
          {gettext("en tu cuenta ahora.")}
        </:subtitle>
      </.header>

      <.simple_form
        for={@form}
        id="registration_form"
        phx-submit="save"
        phx-change="validate"
        phx-trigger-action={@trigger_submit}
        action={~p"/users/log_in?_action=registered"}
        method="post"
      >
        <.error :if={@check_errors}>
          {gettext("Ups, algo salió mal! Por favor, revisa los errores abajo.")}
        </.error>

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
          <.button
            id="8e7ee1fc-342e-42d3-bbad-fd3bb6140e38"
            phx-hook="FormSubmitOnMousedown"
            phx-disable-with={gettext("Creando cuenta...")}
            class="w-full btn btn-primary"
          >
            {gettext("Crear cuenta")}
          </.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  def mount(_params, _session, socket) do
    changeset = Store.change_user_registration(%User{})

    socket =
      socket
      |> assign(trigger_submit: false, check_errors: false)
      |> assign_form(changeset)

    {:ok, socket, temporary_assigns: [form: nil]}
  end

  def handle_event("save", %{"user" => user_params}, socket) do
    case Store.register_user(user_params) do
      {:ok, user} ->
        {:ok, _} =
          Store.deliver_user_confirmation_instructions(
            user,
            &url(~p"/users/confirm/#{&1}")
          )

        changeset = Store.change_user_registration(user)
        {:noreply, socket |> assign(trigger_submit: true) |> assign_form(changeset)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, socket |> assign(check_errors: true) |> assign_form(changeset)}
    end
  end

  def handle_event("validate", %{"user" => user_params}, socket) do
    changeset = Store.change_user_registration(%User{}, user_params)
    {:noreply, assign_form(socket, Map.put(changeset, :action, :validate))}
  end

  defp assign_form(socket, %Ecto.Changeset{} = changeset) do
    form = to_form(changeset, as: "user")

    if changeset.valid? do
      assign(socket, form: form, check_errors: false)
    else
      assign(socket, form: form)
    end
  end
end
