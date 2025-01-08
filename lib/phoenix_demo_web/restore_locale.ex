defmodule PhoenixDemoWeb.RestoreLocale do
  def on_mount(:default, _params, %{"locale" => locale}, socket) do
    Gettext.put_locale(PhoenixDemoWeb.Gettext, locale)
    {:cont, socket}
  end
end
