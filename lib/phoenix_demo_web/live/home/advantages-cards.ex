defmodule PhoenixDemoWeb.Home.AdvantagesCards do
  use Phoenix.Component

  slot :title, required: true
  slot :description, required: true

  def advantages_card(assigns) do
    ~H"""
    <div class="flex flex-col gap-4 items-center p-4 rounded-lg bg-base-100 shadow-xl w-96 sm:h-[380px]">
      {render_slot(@title)}
      {render_slot(@description)}
    </div>
    """
  end
end
