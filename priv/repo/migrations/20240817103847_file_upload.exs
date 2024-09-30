defmodule PhoenixDemo.Repo.Migrations.FileUpload do
  use Ecto.Migration

  def change do
    alter table(:products) do
      add(:images, {:array, :string})
    end
  end
end
