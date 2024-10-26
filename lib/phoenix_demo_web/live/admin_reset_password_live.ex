defmodule PhoenixDemoWeb.AdminResetPasswordLive do
  use PhoenixDemoWeb, :live_view
  import PhoenixDemoWeb.CustomComponents

  alias PhoenixDemo.Accounts

  def render(assigns) do
    ~H"""
    <div class="mx-auto max-w-sm">
      <.header class="text-center">Reset Password</.header>

      <.simple_form
        for={@form}
        id="reset_password_form"
        phx-submit="reset_password"
        phx-change="validate"
      >
        <.error :if={@form.errors != []}>
          Oops, something went wrong! Please check the errors below.
        </.error>

        <.input field={@form[:password]} type="password" label="New password" required />
        <.input
          field={@form[:password_confirmation]}
          type="password"
          label="Confirm new password"
          required
        />
        <:actions>
          <.button phx-disable-with="Resetting..." class="w-full">Reset Password</.button>
        </:actions>
      </.simple_form>

      <p class="text-center text-sm mt-4">
        <.fast_link id="9f9e333c-d882-41ef-ad98-33b545c0db5c" href={~p"/admins/register"}>
          Register
        </.fast_link>
        |
        <.fast_link id="e2e3812b-8aa4-449a-a11f-32bf4df8968a" href={~p"/admins/log_in"}>
          Log in
        </.fast_link>
      </p>
    </div>
    """
  end

  def mount(params, _session, socket) do
    socket = assign_admin_and_token(socket, params)

    form_source =
      case socket.assigns do
        %{admin: admin} ->
          Accounts.change_admin_password(admin)

        _ ->
          %{}
      end

    {:ok, assign_form(socket, form_source), temporary_assigns: [form: nil]}
  end

  # Do not log in the admin after reset password to avoid a
  # leaked token giving the admin access to the account.
  def handle_event("reset_password", %{"admin" => admin_params}, socket) do
    case Accounts.reset_admin_password(socket.assigns.admin, admin_params) do
      {:ok, _} ->
        {:noreply,
         socket
         |> put_flash(:info, "Password reset successfully.")
         |> redirect(to: ~p"/admins/log_in")}

      {:error, changeset} ->
        {:noreply, assign_form(socket, Map.put(changeset, :action, :insert))}
    end
  end

  def handle_event("validate", %{"admin" => admin_params}, socket) do
    changeset = Accounts.change_admin_password(socket.assigns.admin, admin_params)
    {:noreply, assign_form(socket, Map.put(changeset, :action, :validate))}
  end

  defp assign_admin_and_token(socket, %{"token" => token}) do
    if admin = Accounts.get_admin_by_reset_password_token(token) do
      assign(socket, admin: admin, token: token)
    else
      socket
      |> put_flash(:error, "Reset password link is invalid or it has expired.")
      |> redirect(to: ~p"/")
    end
  end

  defp assign_form(socket, %{} = source) do
    assign(socket, :form, to_form(source, as: "admin"))
  end
end
