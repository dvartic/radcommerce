defmodule PhoenixDemo.Schemas.CartItem do
  use Ecto.Schema

  alias PhoenixDemo.Schemas.Cart
  alias PhoenixDemo.Schemas.Product

  import Ecto.Changeset

  schema "cart_items" do
    field :quantity, :integer
    field :properties, :string

    # Cart
    belongs_to :cart, Cart

    # Product
    belongs_to :product, Product

    timestamps()
  end

  def changeset(cart_item, attrs \\ %{}) do
    cart_item
    |> cast(attrs, [:quantity, :properties, :product_id])
    |> validate_required([:quantity, :product_id])
    |> validate_number(:quantity, greater_than_or_equal_to: 1, less_than: 100)
  end
end
