defmodule PhoenixDemoWeb.Layouts.Components.SearchProducts do
  use PhoenixDemoWeb, :live_view

  @impl true
  def mount(_params, session, socket) do
    default_query = Map.get(session["query_params"], "q", "")
    socket = assign(socket, form: to_form(%{"search_query" => default_query}))

    # Place liveview id on socket, to use as id on html
    socket = assign(socket, :liveview_id, socket.id)
    {:ok, socket}
  end

  @impl true
  def handle_event("save", %{"search_query" => search_query}, socket) do
    # Routing

    socket =
      if String.length(search_query) == 0 do
        push_navigate(socket, to: ~p"/products")
      else
        push_navigate(socket, to: ~p"/products?q=#{search_query}")
      end

    {:noreply, socket}
  end

  @impl true
  def handle_event("validate", _values, socket) do
    {:noreply, socket}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <.form for={@form} phx-submit="save" phx-change="validate" autocomplete="off">
      <label
        class="input input-bordered flex flex-row items-center gap-2 w-full min-w-10"
        for={@liveview_id <> ":" <> @form[:search_query].id}
      >
        <input
          class="flex-grow"
          placeholder="Buscar"
          type="text"
          name={@form[:search_query].name}
          id={@liveview_id <> ":" <> @form[:search_query].id}
          value={Phoenix.HTML.Form.normalize_value("text", @form[:search_query].value)}
        />
        <.icon class="h-4 w-4 flex-grow-0" name="hero-magnifying-glass" />
      </label>
    </.form>
    """
  end
end
