defmodule PhoenixDemoWeb.AboutLive do
  use PhoenixDemoWeb, :live_view

  @impl true
  def mount(_params, session, socket) do
    locale = Map.get(session, "locale", "es")

    md_file_path =
      Path.join([:code.priv_dir(:phoenix_demo), "static", "content", "about_" <> locale <> ".md"])

    md_file_read = File.read(md_file_path)

    markdown_desc =
      case md_file_read do
        {:ok, md_file} ->
          markdown_desc =
            md_file
            |> MDEx.to_html()
            |> Phoenix.HTML.raw()

          markdown_desc

        {:error, _} ->
          ""
      end

    socket = assign(socket, :markdown_desc, markdown_desc)

    {:ok, socket}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <div class="markdown-render prose">
      {@markdown_desc}
    </div>
    """
  end
end
