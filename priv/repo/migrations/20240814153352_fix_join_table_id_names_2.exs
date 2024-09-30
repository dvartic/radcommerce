defmodule PhoenixDemo.Repo.Migrations.FixJoinTableIdNames2 do
  use Ecto.Migration

  def change do
    alter table(:product_categories) do
      remove :products_id
      remove :categories_id
      add :product_id, references(:products)
      add :categories_id, references(:categories)
    end
  end
end
