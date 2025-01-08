defmodule PhoenixDemo.Repo.Migrations.AddI18nDatabaseSupp do
  use Ecto.Migration

  def change do
    # CREATE LANGUAGE TABLE
    create table(:languages) do
      add :code, :string, null: false
      add :name, :string, null: false

      timestamps()
    end

    create unique_index(:languages, [:code])

    # CREATE TEXT CONTENT TABLE
    create table(:text_contents) do
      # Using :text instead of :string for potentially longer content
      add :original_text, :text, null: false
      add :language_id, references(:languages), null: false

      timestamps()
    end

    create index(:text_contents, [:language_id])

    # CREATE TRANSLATIONS TABLE
    create table(:translations) do
      add :translated_text, :text, null: false
      add :text_content_id, references(:text_contents), null: false
      add :language_id, references(:languages), null: false

      timestamps()
    end

    # Index for foreign keys
    create index(:translations, [:text_content_id])
    create index(:translations, [:language_id])

    # Unique composite index to prevent duplicate translations
    create unique_index(:translations, [:text_content_id, :language_id],
             name: :translations_text_content_id_language_id_index
           )
  end
end
