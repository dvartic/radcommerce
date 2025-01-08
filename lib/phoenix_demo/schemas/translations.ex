defmodule PhoenixDemo.Schemas.Translations do
  use Ecto.Schema

  import Ecto.Changeset

  schema "translations" do
    field :translated_text, :string
    belongs_to :text_content, PhoenixDemo.Schemas.TextContent
    belongs_to :language, PhoenixDemo.Schemas.Languages

    timestamps()
  end

  def changeset(translation, attrs) do
    translation
    |> cast(attrs, [:translated_text, :text_content_id, :language_id])
    |> validate_required([:translated_text, :text_content_id, :language_id])
    |> foreign_key_constraint(:text_content_id)
    |> foreign_key_constraint(:language_id)
    |> unique_constraint([:text_content_id, :language_id],
      name: :translations_text_content_id_language_id_index,
      message: "Translation for this text in this language already exists"
    )
  end

  def update_changeset(translation, attrs, _metadata \\ []) do
    changeset(translation, attrs)
  end

  def create_changeset(translation, attrs, _metadata \\ []) do
    changeset(translation, attrs)
  end
end
