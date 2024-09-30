defmodule PhoenixDemo.Repo.Migrations.FixUniqueIndexOnProductItems do
  use Ecto.Migration

  def change do
    drop unique_index(:cart_items, [:cart_id, :product_id])

    create index(:cart_items, [:cart_id, :product_id])
  end
end
