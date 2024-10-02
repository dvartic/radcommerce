defmodule PhoenixDemo.JsEnvLoaders do
  def get_stripe_public() do
    Application.fetch_env!(:phoenix_demo, :stripe_public)
  end
end
