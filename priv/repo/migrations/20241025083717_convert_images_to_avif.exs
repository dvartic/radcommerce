defmodule PhoenixDemo.Repo.Migrations.ConvertImagesToAvif do
  use Ecto.Migration

  defp upload_dir, do: Path.join(["uploads", "product", "images"])

  def change do
    execute """
    UPDATE products
    SET images = ARRAY(
      SELECT regexp_replace(image, '\.[^.]+$', '.avif')
      FROM unnest(images) AS image
    )
    """
  end
end
