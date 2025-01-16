defmodule PhoenixDemoWeb.CustomComponents do
  use Phoenix.Component
  import PhoenixDemoWeb.CoreComponents

  alias Phoenix.LiveView.JS

  attr :id, :string, required: true
  attr :show, :boolean, default: false
  attr :on_cancel, JS, default: %JS{}
  attr :direction, :atom, default: :right
  attr :containerClass, :string
  slot :inner_block, required: true

  def drawer(assigns) do
    ~H"""
    <div
      id={@id}
      phx-mounted={@show && show_drawer(@direction, @id)}
      phx-remove={hide_drawer(@direction, @id)}
      data-show-drawer={show_drawer(@direction, @id)}
      data-hide-drawer={hide_drawer(@direction, @id)}
      data-cancel={JS.exec(@on_cancel, "phx-remove")}
      class="relative z-50 hidden"
    >
      <%!-- OVERLAY --%>
      <div
        id={"#{@id}-bg"}
        class="bg-zinc-200/90 fixed inset-0 transition-opacity"
        aria-hidden="true"
      />

      <%!-- CONTENT --%>
      <div
        class={["fixed inset-y-0", if(@direction == :right, do: "right-0", else: "left-0")]}
        aria-labelledby={"#{@id}-title"}
        aria-describedby={"#{@id}-description"}
        role="dialog"
        aria-modal="true"
        tabindex="0"
      >
        <div class="flex min-h-full items-center justify-center">
          <div class={@containerClass}>
            <.focus_wrap
              id={"#{@id}-container"}
              phx-window-keydown={JS.exec("data-cancel", to: "##{@id}")}
              phx-key="escape"
              qphx-mousedown-away={JS.exec("data-cancel", to: "##{@id}")}
              class="relative hidden bg-white p-4 sm:p-8 h-[100dvh]"
            >
              <div class="absolute top-6 right-5">
                <button
                  qphx-mousedown={JS.exec("data-cancel", to: "##{@id}")}
                  type="button"
                  class="-m-3 flex-none p-3 opacity-20 hover:opacity-40"
                  aria-label="close"
                >
                  <.icon name="hero-x-mark-solid" class="h-5 w-5" />
                </button>
              </div>
              <div id={"#{@id}-content"} class="h-full">
                {render_slot(@inner_block)}
              </div>
            </.focus_wrap>
          </div>
        </div>
      </div>
    </div>
    """
  end

  @spec show_drawer(JS, :right | :left, String.t()) :: JS
  def show_drawer(js \\ %JS{}, direction, id) when is_binary(id) do
    translate_from = if direction == :right, do: "translate-x-full", else: "-translate-x-full"

    js
    |> JS.show(to: "##{id}")
    |> JS.show(
      to: "##{id}-bg",
      time: 300,
      transition: {"transition-all transform ease-out duration-300", "opacity-0", "opacity-100"}
    )
    |> JS.show(
      to: "##{id}-container",
      transition: {"ease-out duration-150", translate_from, "translate-x-0"},
      time: 150
    )
    |> JS.focus_first(to: "##{id}-container")
    |> JS.add_class("overflow-hidden", to: "body")
  end

  def hide_drawer(js \\ %JS{}, direction, id) do
    translate_to = if direction == :right, do: "translate-x-full", else: "-translate-x-full"

    js
    |> JS.hide(
      to: "##{id}-bg",
      transition: {"transition-all transform ease-in duration-200", "opacity-100", "opacity-0"}
    )
    |> JS.hide(
      to: "##{id}-container",
      transition: {"ease-in duration-150", "translate-x-0", translate_to},
      time: 150
    )
    |> JS.hide(to: "##{id}", transition: {"block", "block", "hidden"})
    |> JS.remove_class("overflow-hidden", to: "body")
    |> JS.pop_focus()
  end

  attr :id, :string, required: true
  attr :navigate, :string
  attr :patch, :string
  attr :href, :any
  attr :replace, :boolean, default: false
  attr :method, :string, default: "get"
  attr :csrf_token, :any, default: true
  attr :rest, :global, include: ~w(download hreflang referrerpolicy rel target type)
  slot :inner_block, required: true

  def fast_link(%{navigate: to} = assigns) when is_binary(to) do
    ~H"""
    <a
      id={@id}
      href={@navigate}
      data-phx-link="redirect"
      data-phx-link-state={if @replace, do: "replace", else: "push"}
      phx-hook="FastLink"
      {@rest}
    >
      {render_slot(@inner_block)}
    </a>
    """
  end

  def fast_link(%{patch: to} = assigns) when is_binary(to) do
    ~H"""
    <a
      id={@id}
      href={@patch}
      data-phx-link="patch"
      data-phx-link-state={if @replace, do: "replace", else: "push"}
      phx-hook="FastLink"
      {@rest}
    >
      {render_slot(@inner_block)}
    </a>
    """
  end

  def fast_link(%{href: href} = assigns) when href != "#" and not is_nil(href) do
    href = Phoenix.LiveView.Utils.valid_destination!(href, "<.link>")
    assigns = assign(assigns, :href, href)

    ~H"""
    <a
      id={@id}
      href={@href}
      data-method={if @method != "get", do: @method}
      data-csrf={if @method != "get", do: Phoenix.Controller.get_csrf_token()}
      data-to={if @method != "get", do: @href}
      phx-hook="FastLink"
      {@rest}
    >
      {render_slot(@inner_block)}
    </a>
    """
  end
end
