defmodule PhoenixDemo.Repo.Migrations.CreateCartCartItems do
  use Ecto.Migration

  def change do
    create table(:carts) do
      timestamps()
    end

    create table(:cart_items) do
      add :quantity, :integer
      add :cart_id, references(:carts, on_delete: :delete_all)
      add :product_id, references(:products, on_delete: :delete_all)

      timestamps()
    end

    create unique_index(:cart_items, [:cart_id, :product_id])
    create unique_index(:product_categories, [:categories_id, :product_id])
  end
end
