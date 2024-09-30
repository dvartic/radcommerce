defmodule PhoenixDemo.Schemas.Cart do
  use Ecto.Schema
  import Ecto.Changeset

  alias PhoenixDemo.Schemas.CartItem

  schema "carts" do
    # Relationship to Cart Items
    has_many :items, CartItem

    timestamps()
  end

  def changeset(cart, attrs \\ %{}) do
    cart
    |> cast(attrs, [])
  end
end
