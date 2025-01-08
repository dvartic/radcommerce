defmodule PhoenixDemoWeb.Admin.TranslationsLive do
  use Backpex.LiveResource,
    adapter: Backpex.Adapters.Ecto,
    adapter_config: [
      schema: PhoenixDemo.Schemas.Translations,
      repo: PhoenixDemo.Repo,
      update_changeset: &PhoenixDemo.Schemas.Translations.update_changeset/3,
      create_changeset: &PhoenixDemo.Schemas.Translations.create_changeset/3
    ],
    layout: {PhoenixDemoWeb.Layouts, :admin},
    pubsub: [
      name: PhoenixDemo.PubSub,
      topic: "translations",
      event_prefix: "translation_"
    ]

  @impl Backpex.LiveResource
  def singular_name, do: "Translation"

  @impl Backpex.LiveResource
  def plural_name, do: "Translations"

  @impl Backpex.LiveResource
  def fields do
    [
      translated_text: %{
        module: Backpex.Fields.Textarea,
        label: "Translated Text"
      },
      language: %{
        module: Backpex.Fields.BelongsTo,
        label: "Language",
        display_field: :name,
        live_resource: PhoenixDemoWeb.Admin.LanguagesLive
      },
      text_content: %{
        module: Backpex.Fields.BelongsTo,
        label: "Text Content",
        display_field: :original_text,
        live_resource: PhoenixDemoWeb.Admin.TextContentsLive
      }
    ]
  end
end
