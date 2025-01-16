defmodule PhoenixDemo.Repo.Migrations.AddCascadingDelete do
  use Ecto.Migration

  def change do
    alter table(:products) do
      modify :name_id, references(:text_contents, on_delete: :delete_all),
        from: references(:text_contents, on_delete: :nothing)

      modify :description_id, references(:text_contents, on_delete: :delete_all),
        from: references(:text_contents, on_delete: :nothing)

      modify :properties_id, references(:text_contents, on_delete: :delete_all),
        from: references(:text_contents, on_delete: :nothing)
    end

    alter table(:translations) do
      modify :text_content_id, references(:text_contents, on_delete: :delete_all),
        from: references(:text_contents, on_delete: :nothing)
    end

    alter table(:products) do
      remove :example_text_id
    end
  end
end
