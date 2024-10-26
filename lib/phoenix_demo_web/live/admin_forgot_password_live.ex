defmodule PhoenixDemoWeb.AdminForgotPasswordLive do
  use PhoenixDemoWeb, :live_view
  import PhoenixDemoWeb.CustomComponents

  alias PhoenixDemo.Accounts

  def render(assigns) do
    ~H"""
    <div class="mx-auto max-w-sm">
      <.header class="text-center">
        Forgot your password?
        <:subtitle>We'll send a password reset link to your inbox</:subtitle>
      </.header>

      <.simple_form for={@form} id="reset_password_form" phx-submit="send_email">
        <.input field={@form[:email]} type="email" placeholder="Email" required />
        <:actions>
          <.button phx-disable-with="Sending..." class="w-full">
            Send password reset instructions
          </.button>
        </:actions>
      </.simple_form>
      <p class="text-center text-sm mt-4">
        <.fast_link id="60cdcf0d-9bb3-44b5-bce3-a23e06b26f32" href={~p"/admins/register"}>
          Register
        </.fast_link>
        |
        <.fast_link id="2d27198b-0300-4717-adc6-d295cdb66d54" href={~p"/admins/log_in"}>
          Log in
        </.fast_link>
      </p>
    </div>
    """
  end

  def mount(_params, _session, socket) do
    {:ok, assign(socket, form: to_form(%{}, as: "admin"))}
  end

  def handle_event("send_email", %{"admin" => %{"email" => email}}, socket) do
    if admin = Accounts.get_admin_by_email(email) do
      Accounts.deliver_admin_reset_password_instructions(
        admin,
        &url(~p"/admins/reset_password/#{&1}")
      )
    end

    info =
      "If your email is in our system, you will receive instructions to reset your password shortly."

    {:noreply,
     socket
     |> put_flash(:info, info)
     |> redirect(to: ~p"/")}
  end
end
