defmodule PhoenixDemoWeb.Admin.CategoriesLive do
  use Backpex.LiveResource,
    layout: {PhoenixDemoWeb.Layouts, :admin},
    adapter: Backpex.Adapters.Ecto,
    adapter_config: [
      schema: PhoenixDemo.Schemas.Categories,
      repo: PhoenixDemo.Repo,
      update_changeset: &PhoenixDemo.Schemas.Categories.update_changeset/3,
      create_changeset: &PhoenixDemo.Schemas.Categories.create_changeset/3
    ],
    pubsub: [
      name: PhoenixDemo.PubSub,
      topic: "categories",
      event_prefix: "category_"
    ]

  @impl Backpex.LiveResource
  def singular_name, do: "Category"

  @impl Backpex.LiveResource
  def plural_name, do: "Categories"

  @impl Backpex.LiveResource
  def fields do
    [
      name: %{
        module: Backpex.Fields.Text,
        label: "Name"
      }
    ]
  end
end
