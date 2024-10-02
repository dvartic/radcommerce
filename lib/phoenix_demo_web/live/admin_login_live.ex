defmodule PhoenixDemoWeb.AdminLoginLive do
  use PhoenixDemoWeb, :live_view

  alias PhoenixDemo.Accounts

  def render(assigns) do
    ~H"""
    <div class="mx-auto max-w-sm">
      <.header class="text-center">
        Log in to account
        <:subtitle>
          <%= if @exists? == false do %>
            Don't have an account?
            <.link navigate={~p"/admins/register"} class="font-semibold text-brand hover:underline">
              Sign up
            </.link>
            for an account now.
          <% end %>
        </:subtitle>
      </.header>

      <.simple_form for={@form} id="login_form" action={~p"/admins/log_in"} phx-update="ignore">
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
          <.input field={@form[:remember_me]} type="checkbox" label="Keep me logged in" />
          <.link href={~p"/admins/reset_password"} class="text-sm font-semibold">
            Forgot your password?
          </.link>
        </:actions>
        <:actions>
          <.button phx-disable-with="Logging in..." class="w-full btn btn-primary">
            Log in <span aria-hidden="true">→</span>
          </.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  def mount(_params, _session, socket) do
    email = Phoenix.Flash.get(socket.assigns.flash, :email)
    form = to_form(%{"email" => email}, as: "admin")
    exists? = Accounts.admin_one_exists()

    {:ok,
     socket
     |> assign(exists?: exists?)
     |> assign(form: form), temporary_assigns: [form: form]}
  end
end
