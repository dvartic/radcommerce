defmodule PhoenixDemo.Carts do
  alias PhoenixDemo.Repo
  alias PhoenixDemo.Schemas.Cart
  alias PhoenixDemo.Schemas.CartItem

  def create_cart(attr) do
    Cart.changeset(%Cart{}, attr)
    |> Repo.insert()
  end

  def get_cart(id) do
    Repo.get(Cart, id)
  end

  def get_cart_with_products(id) do
    Repo.get(Cart, id)
    |> Repo.preload(items: :product)
  end

  def add_to_cart(id, product_id, properties_str) do
    cart = get_cart_with_products(id)

    # If item exists, update individually increasing quantity by 1
    cart_items = cart.items

    found_cart_item =
      Enum.find(cart_items, fn item ->
        Map.get(item.product || %{}, :id) == product_id && item.properties == properties_str
      end)

    if found_cart_item != nil do
      new_cart_item =
        found_cart_item
        |> CartItem.changeset(%{quantity: found_cart_item.quantity + 1})
        |> Repo.update!()

      # Replace cart_item in existing cart to return
      %{
        cart
        | :items =>
            Enum.map(cart.items, fn cart_item ->
              if cart_item.id == new_cart_item.id, do: new_cart_item, else: cart_item
            end)
      }
    else
      new_cart_item =
        cart
        |> Ecto.build_assoc(:items)
        |> CartItem.changeset(%{quantity: 1, properties: properties_str, product_id: product_id})
        |> Repo.insert!()
        |> Repo.preload(:product)

      # Add cart_item to existing cart to return
      %{cart | :items => cart.items ++ [new_cart_item]}
    end
  end

  def delete_cart_item_id(cart_item_id) do
    cart_item = Repo.get!(CartItem, cart_item_id)
    Repo.delete!(cart_item)
  end

  def update_cart_item_quantity(cart_item_id, quantity) do
    cart_item = Repo.get!(CartItem, cart_item_id)

    cart_item
    |> CartItem.changeset(%{quantity: quantity})
    |> Repo.update!()
    |> Repo.preload(:product)
  end
end
