defmodule PhoenixDemo.Repo.Migrations.CreateOrders do
  use Ecto.Migration

  def change do
    create table(:orders) do
      add :order_number, :string, null: false
      add :status, :string, null: false, default: "processing"
      add :shipping_amount, :decimal, precision: 10, scale: 2
      add :product_list, :jsonb
      add :order_info, :jsonb

      # Relationship
      add :user_id, references(:users, on_delete: :delete_all)

      timestamps()
    end

    create unique_index(:orders, [:order_number])
    create index(:orders, [:status])
    create index(:orders, [:user_id])
  end
end
