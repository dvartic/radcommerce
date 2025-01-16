defmodule PhoenixDemo.Schemas.TextContent do
  use Ecto.Schema

  import Ecto.Changeset

  schema "text_contents" do
    field :original_text, :string
    has_many :translations, PhoenixDemo.Schemas.Translations
    has_one :product, PhoenixDemo.Schemas.Product

    timestamps()
  end

  def changeset(text_content, attrs) do
    text_content
    |> cast(attrs, [:original_text])
    |> validate_required([:original_text])
  end

  def update_changeset(text_content, attrs, _metadata \\ []) do
    changeset(text_content, attrs)
  end

  def create_changeset(text_content, attrs, _metadata \\ []) do
    changeset(text_content, attrs)
  end
end
