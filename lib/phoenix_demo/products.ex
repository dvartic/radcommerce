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
      from(products in Product,
        order_by: [desc: :inserted_at],
        preload: [
          description: [translations: :language],
          properties: [translations: :language],
          name: [translations: :language]
        ]
      )

    Repo.all(query)
  end

  def list_products_by_cat(cat_id) do
    query =
      from(products in Product,
        order_by: [desc: :inserted_at],
        join: cat in assoc(products, :categories),
        where: cat.id == ^cat_id,
        distinct: products.id,
        preload: [
          description: [translations: :language],
          properties: [translations: :language],
          name: [translations: :language]
        ]
      )

    Repo.all(query)
  end

  def search_products(search_query) do
    ilike_query = "%" <> search_query <> "%"

    query =
      from products in Product,
        join: name in assoc(products, :name),
        left_join: translations in assoc(name, :translations),
        where: ilike(name.original_text, ^ilike_query) or ilike(translations.translated_text, ^ilike_query),
        distinct: products.id,
        preload: [
          description: [translations: :language],
          properties: [translations: :language],
          name: [translations: :language]
        ]

    Repo.all(query)
  end

  def get_random_sample_products(limit) do
    query =
      from Product,
        order_by: fragment("RANDOM()"),
        limit: ^limit,
        preload: [
          description: [translations: :language],
          properties: [translations: :language],
          name: [translations: :language]
        ]

    Repo.all(query)
  end

  def get_product(id) do
    Repo.one(
      from product in Product,
        where: product.id == ^id,
        preload: [
          name: [translations: :language],
          description: [translations: :language],
          properties: [translations: :language]
        ]
    )
  end
end
