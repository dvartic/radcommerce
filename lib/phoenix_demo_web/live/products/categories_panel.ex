defmodule PhoenixDemoWeb.Products.CategoriesPanel do
  use Phoenix.Component
  use PhoenixDemoWeb, :verified_routes
  use Gettext, backend: PhoenixDemoWeb.Gettext

  attr :categories, :list, required: true
  attr :selected_cat_id, :integer, required: true

  def product_categories(assigns) do
    ~H"""
    <div class="flex flex-col gap-3">
      <.link
        class={"link" <> if(@selected_cat_id != nil, do: " " <> "link-hover", else: "")}
        navigate={~p"/products"}
      >
        <%= gettext("Todos") %>
      </.link>
      <%= for category <- @categories do %>
        <.link
          class={"link" <> if(category.id != @selected_cat_id, do: " " <> "link-hover", else: "")}
          navigate={~p"/products?cat=#{category.id}"}
        >
          <%= category.name %>
        </.link>
      <% end %>
    </div>
    """
  end
end
