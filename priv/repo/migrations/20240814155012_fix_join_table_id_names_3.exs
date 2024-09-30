defmodule PhoenixDemo.Repo.Migrations.FixJoinTableIdNames3 do
  use Ecto.Migration

  def change do
    alter table(:product_categories, primary_key: false) do
      remove :product_id
      remove :categories_id
      add :product_id, references(:products)
      add :categories_id, references(:categories)
    end
  end
end
