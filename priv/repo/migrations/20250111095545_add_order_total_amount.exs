defmodule PhoenixDemo.Repo.Migrations.AddOrderTotalAmount do
  use Ecto.Migration

  def change do
    alter table(:orders) do
      add :total_amount, :decimal, precision: 10, scale: 2
    end
  end
end
