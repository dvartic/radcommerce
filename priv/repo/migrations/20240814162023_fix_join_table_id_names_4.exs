defmodule PhoenixDemo.Repo.Migrations.FixJoinTableIdNames4 do
  use Ecto.Migration

  def change do
    # Join table and relationships
    drop table(:product_categories)
  end
end
