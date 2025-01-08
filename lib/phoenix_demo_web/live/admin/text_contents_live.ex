defmodule PhoenixDemoWeb.Admin.TextContentsLive do
  use Backpex.LiveResource,
    adapter: Backpex.Adapters.Ecto,
    adapter_config: [
      schema: PhoenixDemo.Schemas.TextContent,
      repo: PhoenixDemo.Repo,
      update_changeset: &PhoenixDemo.Schemas.TextContent.update_changeset/3,
      create_changeset: &PhoenixDemo.Schemas.TextContent.create_changeset/3
    ],
    layout: {PhoenixDemoWeb.Layouts, :admin},
    pubsub: [
      name: PhoenixDemo.PubSub,
      topic: "text_contents",
      event_prefix: "text_content_"
    ]

  @impl Backpex.LiveResource
  def singular_name, do: "TextContent"

  @impl Backpex.LiveResource
  def plural_name, do: "TextContents"

  @impl Backpex.LiveResource
  def fields do
    [
      translations: %{
        module: Backpex.Fields.HasMany,
        label: "Translations",
        display_field: :translated_text,
        live_resource: PhoenixDemoWeb.Admin.TranslationsLive
      },
      original_text: %{
        module: Backpex.Fields.Text,
        label: "Original Text"
      }
    ]
  end
end
