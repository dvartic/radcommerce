defmodule PhoenixDemo.Schemas.LegalPages do
  use Ecto.Schema

  import Ecto.Changeset

  schema "legal_pages" do
    field :name, :string
    field :content, :string

    timestamps()
  end

  def changeset(page, attrs \\ %{}) do
    page
    |> cast(attrs, [:name, :content])
    |> validate_required([:name, :content])
    |> unique_constraint([:name])
  end

  def update_changeset(page, attrs, _metadata \\ []) do
    changeset(page, attrs)
  end

  def create_changeset(page, attrs, _metadata \\ []) do
    changeset(page, attrs)
  end
end
