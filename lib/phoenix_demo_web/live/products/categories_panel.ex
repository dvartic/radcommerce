defmodule PhoenixDemoWeb.Products.CategoriesPanel do
  use Phoenix.Component
  use PhoenixDemoWeb, :verified_routes
  use Gettext, backend: PhoenixDemoWeb.Gettext
  import PhoenixDemoWeb.CoreComponents
  import PhoenixDemoWeb.CustomComponents

  attr :categories, :list, required: true
  attr :selected_cat_id, :integer, required: true

  def product_categories(assigns) do
    ~H"""
    <%!-- MOBILE DROPDOWN --%>
    <div class="sm:hidden dropdown">
      <div tabindex="0" role="button" class="btn btn-sm m-1">
        {if @selected_cat_id,
          do:
            Map.get(
              Enum.find(@categories, fn category -> category.id == @selected_cat_id end),
              :name,
              gettext("Todos")
            ),
          else: gettext("Todos")}
        <.icon name="hero-chevron-down" class="w-4 h-4" />
      </div>
      <ul tabindex="0" class="dropdown-content menu bg-base-100 rounded-box z-50 w-52 p-2 shadow">
        <li>
          <.fast_link id="3d02dc4e-55c9-4e8c-aa17-24d60742678e" navigate={~p"/products"}>
            {gettext("Todos")}
          </.fast_link>
        </li>
        <%= for category <- @categories do %>
          <li>
            <.fast_link
              id={"1c132e3e-5a3b-4b0f-9b94-99c45b45f55e:#{category.id}"}
              navigate={~p"/products?cat=#{category.id}"}
            >
              {category.name}
            </.fast_link>
          </li>
        <% end %>
      </ul>
    </div>

    <%!-- DESKTOP LIST --%>
    <div class="hidden sm:flex flex-col gap-3">
      <.fast_link
        id="67c3adb7-5eb2-4258-8bc7-9802650cf543"
        class={"link" <> if(@selected_cat_id != nil, do: " " <> "link-hover", else: "")}
        navigate={~p"/products"}
      >
        {gettext("Todos")}
      </.fast_link>
      <%= for category <- @categories do %>
        <.fast_link
          id={"6bee9d42-c93b-4c9c-abf9-7640320ca81f:#{category.id}"}
          class={"link" <> if(category.id != @selected_cat_id, do: " " <> "link-hover", else: "")}
          navigate={~p"/products?cat=#{category.id}"}
        >
          {category.name}
        </.fast_link>
      <% end %>
    </div>
    """
  end
end
