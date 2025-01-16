defmodule PhoenixDemo.Repo.Migrations.AddStripeIdAndChangeUuidToBinary do
  use Ecto.Migration

  def change do
    execute "UPDATE orders SET order_number = gen_random_uuid()::text WHERE order_number IS NOT NULL"

    alter table(:orders) do
      add :stripe_id, :string
    end

    execute "ALTER TABLE orders ALTER COLUMN order_number TYPE uuid USING order_number::uuid"
  end
end
