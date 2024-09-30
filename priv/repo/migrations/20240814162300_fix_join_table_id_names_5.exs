defmodule PhoenixDemo.Repo.Migrations.FixJoinTableIdNames5 do
  use Ecto.Migration

  def change do
    create table("product_categories") do
      add :product_id, references(:products)
      add :category_id, references(:categories)
    end
  end
end
