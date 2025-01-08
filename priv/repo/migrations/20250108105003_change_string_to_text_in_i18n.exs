defmodule PhoenixDemo.Repo.Migrations.ChangeStringToTextInI18n do
  use Ecto.Migration

  def change do
    alter table(:text_contents) do
      modify :original_text, :text
    end

    alter table(:translations) do
      modify :translated_text, :text
    end
  end
end
