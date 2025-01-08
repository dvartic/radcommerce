defmodule PhoenixDemo.Repo.Migrations.FixMissingRelId do
  use Ecto.Migration

  def change do
    alter table(:text_contents) do
      add :translation_id, references(:translations), null: true
    end

    create index(:text_contents, [:translation_id])
  end
end
