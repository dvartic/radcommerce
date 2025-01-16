defmodule PhoenixDemo.Repo.Migrations.AddIsActiveFieldToProducts do
  use Ecto.Migration

  def change do
    alter table(:products) do
      add :is_active, :boolean, default: true
    end
  end
end
