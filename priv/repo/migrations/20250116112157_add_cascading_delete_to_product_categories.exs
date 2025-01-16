defmodule PhoenixDemo.Repo.Migrations.AddCascadingDeleteToProductCategories do
  use Ecto.Migration

  def change do
    alter table(:product_categories) do
      modify :product_id, references(:products, on_delete: :delete_all),
        from: references(:products, on_delete: :nothing)

      modify :categories_id, references(:categories, on_delete: :delete_all),
        from: references(:categories, on_delete: :nothing)
    end
  end
end
