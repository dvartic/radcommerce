defmodule PhoenixDemo.Repo.Migrations.FixTableName do
  use Ecto.Migration

  def change do
    rename table(:products), :title_id, to: :example_text_id
  end
end
