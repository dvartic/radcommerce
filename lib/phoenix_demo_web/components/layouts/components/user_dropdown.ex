defmodule PhoenixDemoWeb.Layouts.Components.UserDropdown do
  use Phoenix.Component
  import PhoenixDemoWeb.CoreComponents
  import PhoenixDemoWeb.CustomComponents
  use Gettext, backend: PhoenixDemoWeb.Gettext

  attr :current_user, :any, required: true

  def user_dropdown(assigns) do
    ~H"""
    <details
      id="2952c1b8-4517-4194-a1cc-53dac9e38d50"
      class="dropdown dropdown-end"
      phx-hook="DetailsDropdownClickOutside"
    >
      <summary
        id="user-dropdown-summary"
        phx-hook="SummaryMouseDown"
        class="btn btn-square rounded-md btn-sm md:btn-md m-1 relative"
      >
        <.icon name="hero-user" class="h-3 w-3 md:h-4 md:w-4" />
        <%= if @current_user do %>
          <.icon
            name="hero-check"
            class="m-[2px] md:m-0.5 h-2.5 w-2.5 md:h-3 md:w-3 absolute top-0 right-0 text-green-700"
          />
        <% end %>
      </summary>
      <ul class="menu dropdown-content bg-base-100 rounded-box z-[1] p-3 shadow">
        <%= if @current_user do %>
          <div class="w-full flex flex-row items-center justify-center text-center mb-3">
            <span class="text-base font-bold">{@current_user.email}</span>
          </div>
          <li>
            <.fast_link
              id="ed787ae3-c8dd-4dac-9b6d-d5265a350df4"
              navigate="/users/orders"
              class="text-nowrap"
            >
              {gettext("Panel")}
            </.fast_link>
          </li>
          <li>
            <.link
              id="bf73a091-8ebf-4b6b-a618-81638c367557"
              href="/users/log_out"
              method="delete"
              class="text-nowrap"
            >
              {gettext("Cerrar sesión")}
            </.link>
          </li>
        <% else %>
          <li>
            <.fast_link
              id="2e5ccbee-5497-43bf-8a80-d8b71c1955dd"
              navigate="/users/log_in"
              class="text-nowrap"
            >
              {gettext("Iniciar sesión")}
            </.fast_link>
          </li>
          <li>
            <.fast_link
              id="5914b88c-6e81-4979-8e05-f81d07e36573"
              navigate="/users/register"
              class="text-nowrap"
            >
              {gettext("Registrarse")}
            </.fast_link>
          </li>
        <% end %>
      </ul>
    </details>
    """
  end
end
