defmodule PhoenixDemo.Repo.Migrations.AddOrderDate do
  use Ecto.Migration

  def change do
    alter table(:orders) do
      add :date, :utc_datetime
    end
  end
end
