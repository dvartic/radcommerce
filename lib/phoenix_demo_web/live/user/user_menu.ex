defmodule PhoenixDemoWeb.User.UserMenu do
  use Phoenix.Component
  use Gettext, backend: PhoenixDemoWeb.Gettext
  use PhoenixDemoWeb, :verified_routes
  import PhoenixDemoWeb.CoreComponents
  import PhoenixDemoWeb.CustomComponents

  def user_menu(assigns) do
    ~H"""
    <div
      role="tablist"
      class="max-w-5xl mx-auto tabs tabs-bordered mb-12"
      x-data="{ currentPath: window.location.pathname }"
    >
      <.fast_link
        id="7f1e09cf-765c-4be7-8767-ad90e5908ba6"
        navigate={~p"/users/orders"}
        role="tab"
        class="tab flex flex-row items-center gap-2"
        {%{"x-bind:class" => "{ 'tab-active': currentPath === '/users/orders' }"}}
      >
        <.icon name="hero-list-bullet" class="h-4 w-4" /> {gettext("Pedidos")}
      </.fast_link>
      <.fast_link
        id="8a5ae6df-5c48-40d5-a538-4159564c55bb"
        navigate={~p"/users/settings"}
        role="tab"
        class="tab flex flex-row items-center gap-2"
        {%{"x-bind:class" => "{ 'tab-active': currentPath === '/users/settings' }"}}
      >
        <.icon name="hero-cog-6-tooth" class="h-4 w-4" /> {gettext("Configuración")}
      </.fast_link>
    </div>
    """
  end
end
