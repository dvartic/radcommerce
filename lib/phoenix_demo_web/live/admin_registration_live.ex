defmodule PhoenixDemoWeb.AdminRegistrationLive do
  use PhoenixDemoWeb, :live_view
  import PhoenixDemoWeb.CustomComponents
  alias PhoenixDemo.Accounts
  alias PhoenixDemo.Accounts.Admin

  def render(assigns) do
    ~H"""
    <div class="mx-auto max-w-sm">
      <.header class="text-center">
        Register for an account
        <:subtitle>
          Already registered?
          <.fast_link
            id="a886c313-9247-47b7-96e4-a9a1fe7bb6aa"
            navigate={~p"/admins/log_in"}
            class="font-semibold text-brand hover:underline"
          >
            Log in
          </.fast_link>
          to your account now.
        </:subtitle>
      </.header>

      <.simple_form
        for={@form}
        id="registration_form"
        phx-submit="save"
        phx-change="validate"
        phx-trigger-action={@trigger_submit}
        action={~p"/admins/log_in?_action=registered"}
        method="post"
      >
        <.error :if={@check_errors}>
          Oops, something went wrong! Please check the errors below.
        </.error>

        <.input
          field={@form[:email]}
          type="email"
          label="Email"
          required
          class="input input-bordered"
        />
        <.input
          field={@form[:password]}
          type="password"
          label="Password"
          required
          class="input input-bordered"
        />

        <:actions>
          <.button phx-disable-with="Creating account..." class="w-full btn btn-primary">
            Create an account
          </.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  def mount(_params, _session, socket) do
    changeset = Accounts.change_admin_registration(%Admin{})

    socket =
      socket
      |> assign(trigger_submit: false, check_errors: false)
      |> assign_form(changeset)

    {:ok, socket, temporary_assigns: [form: nil]}
  end

  def handle_event("save", %{"admin" => admin_params}, socket) do
    case Accounts.register_admin(admin_params) do
      {:ok, admin} ->
        {:ok, _} =
          Accounts.deliver_admin_confirmation_instructions(
            admin,
            &url(~p"/admins/confirm/#{&1}")
          )

        changeset = Accounts.change_admin_registration(admin)
        {:noreply, socket |> assign(trigger_submit: true) |> assign_form(changeset)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, socket |> assign(check_errors: true) |> assign_form(changeset)}
    end
  end

  def handle_event("validate", %{"admin" => admin_params}, socket) do
    changeset = Accounts.change_admin_registration(%Admin{}, admin_params)
    {:noreply, assign_form(socket, Map.put(changeset, :action, :validate))}
  end

  defp assign_form(socket, %Ecto.Changeset{} = changeset) do
    form = to_form(changeset, as: "admin")

    if changeset.valid? do
      assign(socket, form: form, check_errors: false)
    else
      assign(socket, form: form)
    end
  end
end
