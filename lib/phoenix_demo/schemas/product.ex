defmodule PhoenixDemo.Schemas.Product do
  use Ecto.Schema

  import Ecto.Changeset

  alias PhoenixDemo.Schemas.Categories

  schema "products" do
    field :name, :string
    field :price, Backpex.Ecto.Amount.Type, currency: :EUR, opts: [separator: ".", delimiter: ","]
    field :description, :string
    field :properties, :string
    field :images, {:array, :string}

    timestamps()

    # Relationship to categories
    many_to_many :categories, Categories, join_through: "product_categories", on_replace: :delete
  end

  def changeset(product, attrs \\ %{}) do
    product
    |> cast(attrs, [:name, :price, :description, :properties, :images])
    |> validate_required([:name, :price, :description])
    |> validate_length(:images, max: 20)
  end

  def update_changeset(product, attrs, _metadata \\ []) do
    changeset(product, attrs)
  end

  def create_changeset(product, attrs, _metadata \\ []) do
    changeset(product, attrs)
  end
end
