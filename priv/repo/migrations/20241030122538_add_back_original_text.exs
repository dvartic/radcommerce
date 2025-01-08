defmodule PhoenixDemo.Repo.Migrations.AddBackOriginalText do
  use Ecto.Migration

  def change do
    alter table(:text_contents) do
      add :original_text, :text
    end
  end
end
