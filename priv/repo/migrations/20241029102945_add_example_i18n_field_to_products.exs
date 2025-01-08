defmodule PhoenixDemo.Repo.Migrations.AddExampleI18nFieldToProducts do
  use Ecto.Migration

  def change do
    alter table(:products) do
      add :title_id, references(:text_contents)
    end
  end
end
