defmodule PhoenixDemo.Repo.Migrations.RemoveOriginalTextSystem do
  use Ecto.Migration

  def change do
    drop index(:text_contents, [:language_id])

    alter table(:text_contents) do
      remove :original_text
      remove :language_id
    end
  end
end
