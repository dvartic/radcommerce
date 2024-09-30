defmodule PhoenixDemo.Repo.Migrations.FixJoinTableIdNames7 do
  use Ecto.Migration

  def change do
    alter table("product_categories") do
      remove :category_id, references(:categories)
    end
  end
end
