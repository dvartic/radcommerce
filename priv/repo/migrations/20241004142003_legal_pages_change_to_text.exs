defmodule PhoenixDemo.Repo.Migrations.LegalPagesChangeToText do
  use Ecto.Migration

  def change do
    alter table(:legal_pages) do
      modify :content, :text
    end
  end
end
