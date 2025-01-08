defmodule PhoenixDemoWeb.Admin.ProductsLive do
  use Backpex.LiveResource,
    adapter: Backpex.Adapters.Ecto,
    adapter_config: [
      schema: PhoenixDemo.Schemas.Product,
      repo: PhoenixDemo.Repo,
      update_changeset: &PhoenixDemo.Schemas.Product.update_changeset/3,
      create_changeset: &PhoenixDemo.Schemas.Product.create_changeset/3
    ],
    layout: {PhoenixDemoWeb.Layouts, :admin},
    pubsub: [
      name: PhoenixDemo.PubSub,
      topic: "products",
      event_prefix: "product_"
    ]

  @impl Backpex.LiveResource
  def singular_name, do: "Product"

  @impl Backpex.LiveResource
  def plural_name, do: "Products"

  @impl Backpex.LiveResource
  def fields do
    [
      name: %{
        module: Backpex.Fields.BelongsTo,
        label: "Name",
        display_field: :original_text,
        live_resource: PhoenixDemoWeb.Admin.TextContentsLive
      },
      price: %{
        module: Backpex.Fields.Number,
        label: "Price"
      },
      description: %{
        module: Backpex.Fields.BelongsTo,
        label: "Description",
        display_field: :original_text,
        live_resource: PhoenixDemoWeb.Admin.TextContentsLive
      },
      properties: %{
        module: Backpex.Fields.BelongsTo,
        label: "Properties",
        display_field: :original_text,
        live_resource: PhoenixDemoWeb.Admin.TextContentsLive
      },
      categories: %{
        module: Backpex.Fields.HasMany,
        label: "Categories",
        display_field: :name,
        live_resource: PhoenixDemoWeb.Admin.CategoriesLive
      },
      images: %{
        module: Backpex.Fields.Upload,
        label: "Images",
        upload_key: :images,
        accept: ~w(.jpg .jpeg .png),
        max_entries: 20,
        max_file_size: 8_000_000,
        put_upload_change: &put_upload_change/6,
        consume_upload: &consume_upload/4,
        remove_uploads: &remove_uploads/3,
        list_existing_files: &list_existing_files/1,
        render: fn
          %{value: value} = assigns when is_list(value) ->
            ~H'''
            <div>
              <img :for={img <- @value} class="h-32 w-auto" src={file_url(img)} />
            </div>
            '''

          assigns ->
            ~H'<p>{Backpex.HTML.pretty_value(@value)}</p>'
        end,
        except: [:index, :resource_action],
        align: :center
      },
      example_text: %{
        module: Backpex.Fields.BelongsTo,
        label: "Example Text",
        display_field: :original_text,
        live_resource: PhoenixDemoWeb.Admin.TextContentsLive
      }
    ]
  end

  defp list_existing_files(%{images: images} = _item) when is_list(images), do: images
  defp list_existing_files(_item), do: []

  defp put_upload_change(_socket, params, item, uploaded_entries, removed_entries, action) do
    existing_files = list_existing_files(item) -- removed_entries

    new_entries =
      case action do
        :validate ->
          elem(uploaded_entries, 1)

        :insert ->
          elem(uploaded_entries, 0)
      end

    files = existing_files ++ Enum.map(new_entries, fn entry -> file_name(entry) end)

    Map.put(params, "images", files)
  end

  # Silence Dialyzer due to improper detection on Image.write
  @dialyzer {:nowarn_function,
             [
               consume_upload: 4
             ]}
  defp consume_upload(_socket, _item, %{path: path} = _meta, entry) do
    file_name = file_name(entry)
    base_path = Path.join([:code.priv_dir(:phoenix_demo), "static", upload_dir()])
    dest = Path.join([base_path, file_name])
    # Ensure destination exists
    if File.dir?(base_path) == false do
      File.mkdir_p!(base_path)
    end

    # Read file
    {:ok, image} = Image.open(path)
    maxCurrSize = max(Image.width(image), Image.height(image))

    # Process
    image
    |> then(fn image ->
      if maxCurrSize > 800 do
        {:ok, resized_image} = Image.resize(image, 800 / maxCurrSize)
        resized_image
      else
        image
      end
    end)
    |> Image.remove_metadata!()
    |> Image.write!(dest,
      quality: 60,
      webp: [minimize_file_size: true, effort: 10],
      heif: [minimize_file_size: true, effort: 8]
    )

    {:ok, file_url(file_name)}
  end

  defp remove_uploads(_socket, _item, removed_entries) do
    for file <- removed_entries do
      path = Path.join([:code.priv_dir(:phoenix_demo), "static", upload_dir(), file])
      File.rm!(path)
    end
  end

  def file_url(file_name) do
    static_path = Path.join([upload_dir(), file_name])
    Phoenix.VerifiedRoutes.static_url(PhoenixDemoWeb.Endpoint, "/" <> static_path)
  end

  defp file_name(entry) do
    # Always use webp
    "#{entry.uuid}.avif"
  end

  defp upload_dir, do: Path.join(["uploads", "product", "images"])
end
