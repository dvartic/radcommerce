defmodule PhoenixDemo.Repo.Migrations.MoveFloatToPrice do
  use Ecto.Migration

  def change do
    alter table(:products) do
      remove :price
      add :price, :integer
    end
  end
end
