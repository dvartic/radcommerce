defmodule PhoenixDemo.Repo.Migrations.CreateLegalPages do
  use Ecto.Migration

  def change do
    create table(:legal_pages) do
      add :name, :string
      add :content, :string
      timestamps()
    end
  end
end
