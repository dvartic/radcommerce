defmodule PhoenixDemo.Schemas.Languages do
  use Ecto.Schema

  import Ecto.Changeset

  schema "languages" do
    field :name, :string
    field :code, :string

    timestamps()
  end

  def changeset(language, attrs) do
    language
    |> cast(attrs, [:code, :name])
    |> validate_required([:code, :name])
    |> unique_constraint(:code)
  end

  def update_changeset(language, attrs, _metadata \\ []) do
    changeset(language, attrs)
  end

  def create_changeset(language, attrs, _metadata \\ []) do
    changeset(language, attrs)
  end
end
