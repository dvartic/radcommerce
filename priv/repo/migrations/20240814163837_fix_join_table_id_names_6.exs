defmodule PhoenixDemo.Repo.Migrations.FixJoinTableIdNames6 do
  use Ecto.Migration

  def change do
    alter table("product_categories") do
      add :categories_id, references(:categories)
    end
  end
end
