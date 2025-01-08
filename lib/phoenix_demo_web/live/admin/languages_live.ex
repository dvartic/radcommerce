defmodule PhoenixDemoWeb.Admin.LanguagesLive do
  use Backpex.LiveResource,
    layout: {PhoenixDemoWeb.Layouts, :admin},
    adapter: Backpex.Adapters.Ecto,
    adapter_config: [
      schema: PhoenixDemo.Schemas.Languages,
      repo: PhoenixDemo.Repo,
      update_changeset: &PhoenixDemo.Schemas.Languages.update_changeset/3,
      create_changeset: &PhoenixDemo.Schemas.Languages.create_changeset/3
    ],
    pubsub: [
      name: PhoenixDemo.PubSub,
      topic: "languages",
      event_prefix: "language_"
    ]

  @impl Backpex.LiveResource
  def singular_name, do: "Language"

  @impl Backpex.LiveResource
  def plural_name, do: "Languages"

  @impl Backpex.LiveResource
  def fields do
    [
      code: %{
        module: Backpex.Fields.Text,
        label: "Code"
      },
      name: %{
        module: Backpex.Fields.Text,
        label: "Name"
      }
    ]
  end
end
