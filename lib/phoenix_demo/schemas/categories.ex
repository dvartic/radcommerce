defmodule PhoenixDemo.Schemas.Categories do
  use Ecto.Schema

  import Ecto.Changeset

  alias PhoenixDemo.Schemas.Product

  schema "categories" do
    field :name, :string
    timestamps()

    # Relationship to products
    many_to_many :products, Product, join_through: "product_categories"
  end

  def changeset(category, attrs \\ %{}) do
    category
    |> cast(attrs, [:name])
    |> validate_required([:name])
  end

  def update_changeset(category, attrs, _metadata \\ []) do
    changeset(category, attrs)
  end

  def create_changeset(category, attrs, _metadata \\ []) do
    changeset(category, attrs)
  end
end
