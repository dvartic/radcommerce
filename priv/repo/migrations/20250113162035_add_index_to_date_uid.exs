defmodule PhoenixDemo.Repo.Migrations.AddIndexToDateUid do
  use Ecto.Migration

  def change do
    create index(:orders, [:user_id, :date])
  end
end
