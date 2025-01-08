defmodule PhoenixDemo.Repo.Migrations.AddProductTranslations do
  use Ecto.Migration

  def up do
    # First add the new ID columns (nullable initially)
    alter table(:products) do
      add :name_id, references(:text_contents)
      add :description_id, references(:text_contents)
      add :properties_id, references(:text_contents)
    end

    # Name translations
    execute """
    INSERT INTO text_contents (original_text, inserted_at, updated_at)
    SELECT name, NOW(), NOW()
    FROM products
    WHERE name IS NOT NULL;
    """

    execute """
    UPDATE products
    SET name_id = text_contents.id
    FROM text_contents
    WHERE text_contents.original_text = products.name;
    """

    # Description translations
    execute """
    INSERT INTO text_contents (original_text, inserted_at, updated_at)
    SELECT description, NOW(), NOW()
    FROM products
    WHERE description IS NOT NULL;
    """

    execute """
    UPDATE products
    SET description_id = text_contents.id
    FROM text_contents
    WHERE text_contents.original_text = products.description;
    """

    # Properties translations
    execute """
    INSERT INTO text_contents (original_text, inserted_at, updated_at)
    SELECT properties, NOW(), NOW()
    FROM products
    WHERE properties IS NOT NULL;
    """

    execute """
    UPDATE products
    SET properties_id = text_contents.id
    FROM text_contents
    WHERE text_contents.original_text = products.properties;
    """

    # Remove the old columns
    alter table(:products) do
      remove :name
      remove :description
      remove :properties
    end

    # Add NOT NULL constraints where needed
    alter table(:products) do
      modify :name_id, :bigint, null: false
      modify :description_id, :bigint, null: false
    end
  end

  def down do
    # Add back the original string columns
    alter table(:products) do
      add :name, :string
      add :description, :text
      add :properties, :text
    end

    # Copy data back from text_contents
    execute """
    UPDATE products
    SET name = text_contents.original_text
    FROM text_contents
    WHERE text_contents.id = products.name_id;
    """

    execute """
    UPDATE products
    SET description = text_contents.original_text
    FROM text_contents
    WHERE text_contents.id = products.description_id;
    """

    execute """
    UPDATE products
    SET properties = text_contents.original_text
    FROM text_contents
    WHERE text_contents.id = products.properties_id;
    """

    # Remove the foreign key columns
    alter table(:products) do
      remove :name_id
      remove :description_id
      remove :properties_id
    end
  end
end
