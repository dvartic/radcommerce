defmodule PhoenixDemo.Repo.Migrations.AddTrackingNumberColumn do
  use Ecto.Migration

  def change do
    alter table(:orders) do
      add :tracking_number, :string
    end
  end
end
