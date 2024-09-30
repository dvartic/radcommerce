defmodule PhoenixDemo.Repo.Migrations.AddIndexesNameLegalProducts do
  use Ecto.Migration

  def change do
    create index(:products, [:name])
    create unique_index(:legal_pages, [:name])
  end
end
