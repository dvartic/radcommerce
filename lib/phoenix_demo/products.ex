defmodule PhoenixDemo.Products do
  import Ecto.Query

  alias PhoenixDemo.Repo
  alias PhoenixDemo.Schemas.Product

  def create_product(attr) do
    Product.changeset(%Product{}, attr)
    |> Repo.insert()
  end

  def list_products() do
    query =
      from(products in Product, order_by: [desc: :inserted_at])

    Repo.all(query)
  end

  def list_products_by_cat(cat_id) do
    query =
      from(products in Product,
        order_by: [desc: :inserted_at],
        join: cat in assoc(products, :categories),
        where: cat.id == ^cat_id,
        distinct: products.id
      )

    Repo.all(query)
  end

  def search_products(search_query) do
    ilike_query = "%" <> search_query <> "%"

    query =
      from products in Product,
        where: ilike(products.name, ^ilike_query)

    Repo.all(query)
  end

  def get_random_sample_products(limit) do
    query =
      from Product,
        order_by: fragment("RANDOM()"),
        limit: ^limit

    Repo.all(query)
  end

  def get_product(id) do
    Repo.get(Product, id)
  end
end
