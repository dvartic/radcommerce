defmodule PhoenixDemo.Repo.Migrations.MovePropertiesToString do
  use Ecto.Migration

  def change do
    alter table(:products) do
      remove :properties
      add :properties, :string
    end
  end
end
