defmodule PhoenixDemo.Repo.Migrations.AddPropertiesToCartItems do
  use Ecto.Migration

  def change do
    alter table(:cart_items) do
      add :properties, :string
    end
  end
end
