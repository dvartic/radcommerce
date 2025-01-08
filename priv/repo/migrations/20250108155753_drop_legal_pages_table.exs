defmodule PhoenixDemo.Repo.Migrations.DropLegalPagesTable do
  use Ecto.Migration

  def change do
    drop table(:legal_pages)
  end
end
