defmodule PhoenixDemoWeb.Utils.Utils do
  alias PhoenixDemoWeb.Admin.ProductsLive

  @doc """
  Resolves an images list into a new list
  """
  def resolve_img_src_list(images) do
    images
    |> Enum.map(fn rel_src -> ProductsLive.file_url(rel_src) end)
    |> then(fn
      list when list == [] -> ["/images/image-off.svg"]
      list -> list
    end)
  end

  @doc """
  Resolves an image list into a single image, taking the first
  """
  def resolve_img_src(images) do
    images
    |> List.first(nil)
    |> then(fn img_src_or_nil ->
      if img_src_or_nil == nil do
        "/images/image-off.svg"
      else
        ProductsLive.file_url(img_src_or_nil)
      end
    end)
  end

  @doc """
  Resolves an image list into a single image, taking the first, but paths passed are expected to be full including domain
  """
  def resolve_img_src_full_path(images) do
    images
    |> List.first(nil)
    |> then(fn img_src_or_nil ->
      if img_src_or_nil == nil do
        "/images/image-off.svg"
      else
        img_src_or_nil
      end
    end)
  end
end
