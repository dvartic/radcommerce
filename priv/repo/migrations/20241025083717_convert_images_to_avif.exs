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

    convert_images_to_avif()
  end

  defp convert_images_to_avif do
    # Define the directory path
    uploads_dir = Path.join([:code.priv_dir(:phoenix_demo), "static", upload_dir()])

    # Read all files from the directory
    files = File.ls!(uploads_dir)

    # Process each file
    Enum.each(files, fn file ->
      case String.ends_with?(file, ".avif") do
        true ->
          nil

        false ->
          file_path = Path.join(uploads_dir, file)
          dest = Path.join(uploads_dir, Path.rootname(file) <> ".avif")

          # Assume that the file is an image

          {:ok, image} = Image.open(file_path)

          image
          |> Image.write!(dest,
            quality: 60,
            webp: [minimize_file_size: true, effort: 10],
            heif: [minimize_file_size: true, effort: 8]
          )

          # Remove original file
          File.rm!(file_path)
      end
    end)
  end
end
