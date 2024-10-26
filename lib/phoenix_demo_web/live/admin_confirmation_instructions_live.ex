defmodule PhoenixDemoWeb.AdminConfirmationInstructionsLive do
  use PhoenixDemoWeb, :live_view
  import PhoenixDemoWeb.CustomComponents

  alias PhoenixDemo.Accounts

  def render(assigns) do
    ~H"""
    <div class="mx-auto max-w-sm">
      <.header class="text-center">
        No confirmation instructions received?
        <:subtitle>We'll send a new confirmation link to your inbox</:subtitle>
      </.header>

      <.simple_form for={@form} id="resend_confirmation_form" phx-submit="send_instructions">
        <.input field={@form[:email]} type="email" placeholder="Email" required />
        <:actions>
          <.button phx-disable-with="Sending..." class="w-full">
            Resend confirmation instructions
          </.button>
        </:actions>
      </.simple_form>

      <p class="text-center mt-4">
        <.fast_link id="249b0bfb-8963-425c-a511-ffe66a75a4a7" href={~p"/admins/register"}>
          Register
        </.fast_link>
        |
        <.fast_link id="8e3aa4d6-db85-445d-af14-6b155c2070b9" href={~p"/admins/log_in"}>
          Log in
        </.fast_link>
      </p>
    </div>
    """
  end

  def mount(_params, _session, socket) do
    {:ok, assign(socket, form: to_form(%{}, as: "admin"))}
  end

  def handle_event("send_instructions", %{"admin" => %{"email" => email}}, socket) do
    if admin = Accounts.get_admin_by_email(email) do
      Accounts.deliver_admin_confirmation_instructions(
        admin,
        &url(~p"/admins/confirm/#{&1}")
      )
    end

    info =
      "If your email is in our system and it has not been confirmed yet, you will receive an email with instructions shortly."

    {:noreply,
     socket
     |> put_flash(:info, info)
     |> redirect(to: ~p"/")}
  end
end
