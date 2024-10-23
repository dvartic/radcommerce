defmodule PhoenixDemoWeb.ChangeLanguageController do
  use PhoenixDemoWeb, :controller

  def change_language(conn, %{"locale" => locale}) do
    conn
    |> put_resp_cookie("locale", locale, max_age: 400 * 24 * 60 * 60)
    |> json(%{success: true})
  end
end
