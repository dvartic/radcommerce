defmodule PhoenixDemoWeb.Layouts.Components.LanguageSelector do
  use PhoenixDemoWeb, :live_view

  on_mount PhoenixDemoWeb.RestoreLocale

  defp known_locales_with_text, do: %{"en" => "🇬🇧 English", "es" => "🇪🇸 Español"}

  @impl true
  def mount(_params, _session, socket) do
    known_locales = Application.get_env(:phoenix_demo, PhoenixDemoWeb.Gettext, ["en"])[:locales]

    locale_list =
      Enum.map(known_locales, fn locale ->
        %{value: locale, text: Map.get(known_locales_with_text(), locale, locale)}
      end)

    current_locale = Gettext.get_locale(PhoenixDemoWeb.Gettext)

    {:ok,
     socket
     |> assign(current_locale: current_locale)
     |> assign(locale_list: locale_list)}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <%!-- FORM HAS A ONCHANGE EVENT LISTENER ATTACHED --%>
    <form id="change_language_form" phx-hook="ChangeLanguageSelector">
      <select name="locale" class="select select-info w-36 select-sm" aria-label="Change language">
        <%= for locale <- @locale_list do %>
          <option selected={locale.value == @current_locale} value={locale.value}>
            {locale.text}
          </option>
        <% end %>
      </select>
    </form>
    """
  end
end
