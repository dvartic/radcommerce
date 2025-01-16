defmodule PhoenixDemoWeb.UserSettingsLive do
  use PhoenixDemoWeb, :live_view
  use Gettext, backend: PhoenixDemoWeb.Gettext
  import PhoenixDemoWeb.User.UserMenu
  alias PhoenixDemo.Store

  def render(assigns) do
    ~H"""
    <.user_menu />
    <.header class="max-w-prose mx-auto text-center">
      {gettext("Configuración de cuenta")}
      <:subtitle>
        {gettext("Administra tu correo electrónico y configuración de contraseña")}
      </:subtitle>
    </.header>

    <div class="max-w-prose mx-auto space-y-12 divide-y">
      <div>
        <.simple_form
          for={@email_form}
          id="email_form"
          phx-submit="update_email"
          phx-change="validate_email"
        >
          <.input
            field={@email_form[:email]}
            type="email"
            label={gettext("Correo electrónico")}
            required
            class="input input-bordered"
          />
          <.input
            field={@email_form[:current_password]}
            name="current_password"
            id="current_password_for_email"
            type="password"
            label={gettext("Contraseña actual")}
            value={@email_form_current_password}
            required
            class="input input-bordered"
          />
          <:actions>
            <.button phx-disable-with={gettext("Cambiando...")} class="w-full btn btn-primary">
              {gettext("Cambiar correo electrónico")}
            </.button>
          </:actions>
        </.simple_form>
      </div>
      <div>
        <.simple_form
          for={@password_form}
          id="password_form"
          action={~p"/users/log_in?_action=password_updated"}
          method="post"
          phx-change="validate_password"
          phx-submit="update_password"
          phx-trigger-action={@trigger_submit}
        >
          <input
            name={@password_form[:email].name}
            type="hidden"
            id="hidden_user_email"
            value={@current_email}
          />
          <.input
            field={@password_form[:password]}
            type="password"
            label={gettext("Nueva contraseña")}
            required
            class="input input-bordered"
          />
          <.input
            field={@password_form[:password_confirmation]}
            type="password"
            label={gettext("Confirmar nueva contraseña")}
            class="input input-bordered"
          />
          <.input
            field={@password_form[:current_password]}
            name="current_password"
            type="password"
            label={gettext("Contraseña actual")}
            id="current_password_for_password"
            value={@current_password}
            required
            class="input input-bordered"
          />
          <:actions>
            <.button phx-disable-with={gettext("Cambiando...")} class="w-full btn btn-primary">
              {gettext("Cambiar contraseña")}
            </.button>
          </:actions>
        </.simple_form>
      </div>
    </div>
    """
  end

  def mount(%{"token" => token}, _session, socket) do
    socket =
      case Store.update_user_email(socket.assigns.current_user, token) do
        :ok ->
          put_flash(socket, :info, gettext("Email cambiado correctamente."))

        :error ->
          put_flash(
            socket,
            :error,
            gettext("El enlace de cambio de email es inválido o ha expirado.")
          )
      end

    {:ok, push_navigate(socket, to: ~p"/users/settings")}
  end

  def mount(_params, _session, socket) do
    user = socket.assigns.current_user
    email_changeset = Store.change_user_email(user)
    password_changeset = Store.change_user_password(user)

    socket =
      socket
      |> assign(:current_password, nil)
      |> assign(:email_form_current_password, nil)
      |> assign(:current_email, user.email)
      |> assign(:email_form, to_form(email_changeset))
      |> assign(:password_form, to_form(password_changeset))
      |> assign(:trigger_submit, false)

    {:ok, socket}
  end

  def handle_event("validate_email", params, socket) do
    %{"current_password" => password, "user" => user_params} = params

    email_form =
      socket.assigns.current_user
      |> Store.change_user_email(user_params)
      |> Map.put(:action, :validate)
      |> to_form()

    {:noreply, assign(socket, email_form: email_form, email_form_current_password: password)}
  end

  def handle_event("update_email", params, socket) do
    %{"current_password" => password, "user" => user_params} = params
    user = socket.assigns.current_user

    case Store.apply_user_email(user, password, user_params) do
      {:ok, applied_user} ->
        Store.deliver_user_update_email_instructions(
          applied_user,
          user.email,
          &url(~p"/users/settings/confirm_email/#{&1}")
        )

        info =
          gettext("Un enlace para confirmar tu cambio de email ha sido enviado al nuevo correo.")

        {:noreply, socket |> put_flash(:info, info) |> assign(email_form_current_password: nil)}

      {:error, changeset} ->
        {:noreply, assign(socket, :email_form, to_form(Map.put(changeset, :action, :insert)))}
    end
  end

  def handle_event("validate_password", params, socket) do
    %{"current_password" => password, "user" => user_params} = params

    password_form =
      socket.assigns.current_user
      |> Store.change_user_password(user_params)
      |> Map.put(:action, :validate)
      |> to_form()

    {:noreply, assign(socket, password_form: password_form, current_password: password)}
  end

  def handle_event("update_password", params, socket) do
    %{"current_password" => password, "user" => user_params} = params
    user = socket.assigns.current_user

    case Store.update_user_password(user, password, user_params) do
      {:ok, user} ->
        password_form =
          user
          |> Store.change_user_password(user_params)
          |> to_form()

        {:noreply, assign(socket, trigger_submit: true, password_form: password_form)}

      {:error, changeset} ->
        {:noreply, assign(socket, password_form: to_form(changeset))}
    end
  end
end
