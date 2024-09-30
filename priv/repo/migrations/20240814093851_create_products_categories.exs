defmodule PhoenixDemo.Repo.Migrations.CreateProductsCategories do
  use Ecto.Migration

  def change do
    create table(:categories) do
      add :name, :string
      timestamps()
    end

    alter table(:products) do
      add :price, :float
      add :description, :string
      add :properties, :map
    end

    # Join table and relationships
    create table(:product_categories) do
      add :product_id, references(:products)
      add :category_id, references(:categories)
      timestamps()
    end
  end
end
