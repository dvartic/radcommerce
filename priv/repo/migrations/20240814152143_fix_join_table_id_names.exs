defmodule PhoenixDemo.Repo.Migrations.FixJoinTableIdNames do
  use Ecto.Migration

  def change do
    # Join table and relationships
    alter table(:product_categories) do
      remove :product_id
      remove :category_id
      add :products_id, references(:products)
      add :categories_id, references(:categories)
    end
  end
end
