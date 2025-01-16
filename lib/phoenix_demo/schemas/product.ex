defmodule PhoenixDemo.Schemas.Product do
  use Ecto.Schema

  import Ecto.Changeset

  alias PhoenixDemo.Schemas.Categories
  alias PhoenixDemo.Schemas.TextContent

  schema "products" do
    belongs_to :name, TextContent
    belongs_to :description, TextContent
    belongs_to :properties, TextContent
    field :images, {:array, :string}
    field :price, Backpex.Ecto.Amount.Type, currency: :EUR, opts: [separator: ".", delimiter: ","]
    field :is_active, :boolean, default: true

    timestamps()

    # Relationship to categories
    many_to_many :categories, Categories, join_through: "product_categories", on_replace: :delete
  end

  def changeset(product, attrs \\ %{}) do
    product
    |> cast(attrs, [:name_id, :price, :description_id, :images, :is_active])
    |> validate_required([:name_id, :price, :description_id])
    |> validate_length(:images, max: 20)
    |> foreign_key_constraint(:name_id)
    |> foreign_key_constraint(:description_id)
    |> foreign_key_constraint(:properties_id)
  end

  def update_changeset(product, attrs, _metadata \\ []) do
    changeset(product, attrs)
  end

  def create_changeset(product, attrs, _metadata \\ []) do
    changeset(product, attrs)
  end
end
