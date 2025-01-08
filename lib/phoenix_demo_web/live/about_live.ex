defmodule PhoenixDemoWeb.AboutLive do
  use PhoenixDemoWeb, :live_view

  alias PhoenixDemo.LegalPages

  @impl true
  def mount(_params, _session, socket) do
    markdown_desc =
      (LegalPages.get_page("about") || %{})
      |> Map.get(:content, "")
      |> MDEx.to_html()
      |> Phoenix.HTML.raw()

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
