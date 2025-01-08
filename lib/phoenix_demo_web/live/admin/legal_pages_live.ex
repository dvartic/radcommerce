defmodule PhoenixDemoWeb.Admin.LegalPagesLive do
  use Backpex.LiveResource,
    adapter: Backpex.Adapters.Ecto,
    adapter_config: [
      schema: PhoenixDemo.Schemas.LegalPages,
      repo: PhoenixDemo.Repo,
      update_changeset: &PhoenixDemo.Schemas.LegalPages.update_changeset/3,
      create_changeset: &PhoenixDemo.Schemas.LegalPages.create_changeset/3
    ],
    layout: {PhoenixDemoWeb.Layouts, :admin},
    pubsub: [
      name: PhoenixDemo.PubSub,
      topic: "legal_pages",
      event_prefix: "legal_page_"
    ]

  @impl Backpex.LiveResource
  def singular_name, do: "LegalPage"

  @impl Backpex.LiveResource
  def plural_name, do: "LegalPages"

  @impl Backpex.LiveResource
  def fields do
    [
      name: %{
        module: Backpex.Fields.Text,
        label: "Name"
      },
      content: %{
        module: Backpex.Fields.Textarea,
        label: "Content"
      }
    ]
  end
end
