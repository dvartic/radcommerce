defmodule PhoenixDemoWeb.UserResetPasswordLive do
  use PhoenixDemoWeb, :live_view
  import PhoenixDemoWeb.CustomComponents
  use Gettext, backend: PhoenixDemoWeb.Gettext

  alias PhoenixDemo.Store

  def render(assigns) do
    ~H"""
    <div class="mx-auto max-w-sm">
      <.header class="text-center">
        {gettext("Restablecer contraseña")}
      </.header>

      <.simple_form
        for={@form}
        id="reset_password_form"
        phx-submit="reset_password"
        phx-change="validate"
      >
        <.error :if={@form.errors != []}>
          {gettext("¡Ups, algo salió mal! Por favor, revisa los errores debajo.")}
        </.error>

        <.input
          field={@form[:password]}
          type="password"
          label={gettext("Nueva contraseña")}
          required
          class="input input-bordered"
        />
        <.input
          field={@form[:password_confirmation]}
          type="password"
          label={gettext("Confirmar nueva contraseña")}
          required
          class="input input-bordered"
        />
        <:actions>
          <.button
            id="77cd96b0-5947-450a-9b60-e3073ce97171"
            phx-hook="FormSubmitOnMousedown"
            phx-disable-with={gettext("Restableciendo...")}
            class="w-full btn btn-primary"
          >
            {gettext("Restablecer contraseña")}
          </.button>
        </:actions>
      </.simple_form>

      <p class="text-center text-sm mt-4">
        <.fast_link id="a9d9909a-e56b-45c2-939a-e7c98bd543f9" href={~p"/users/register"}>
          {gettext("Regístrate")}
        </.fast_link>
        |
        <.fast_link id="9da2d92f-b270-434b-9657-9698c4ffd385" href={~p"/users/log_in"}>
          {gettext("Inicia sesión")}
        </.fast_link>
      </p>
    </div>
    """
  end

  def mount(params, _session, socket) do
    socket = assign_user_and_token(socket, params)

    form_source =
      case socket.assigns do
        %{user: user} ->
          Store.change_user_password(user)

        _ ->
          %{}
      end

    {:ok, assign_form(socket, form_source), temporary_assigns: [form: nil]}
  end

  # Do not log in the user after reset password to avoid a
  # leaked token giving the user access to the account.
  def handle_event("reset_password", %{"user" => user_params}, socket) do
    case Store.reset_user_password(socket.assigns.user, user_params) do
      {:ok, _} ->
        {:noreply,
         socket
         |> put_flash(:info, gettext("Contraseña restablecida correctamente."))
         |> redirect(to: ~p"/users/log_in")}

      {:error, changeset} ->
        {:noreply, assign_form(socket, Map.put(changeset, :action, :insert))}
    end
  end

  def handle_event("validate", %{"user" => user_params}, socket) do
    changeset = Store.change_user_password(socket.assigns.user, user_params)
    {:noreply, assign_form(socket, Map.put(changeset, :action, :validate))}
  end

  defp assign_user_and_token(socket, %{"token" => token}) do
    if user = Store.get_user_by_reset_password_token(token) do
      assign(socket, user: user, token: token)
    else
      socket
      |> put_flash(
        :error,
        gettext("El enlace de restablecimiento de contraseña es inválido o ha expirado.")
      )
      |> redirect(to: ~p"/")
    end
  end

  defp assign_form(socket, %{} = source) do
    assign(socket, :form, to_form(source, as: "user"))
  end
end
