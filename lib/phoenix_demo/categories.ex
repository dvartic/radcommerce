defmodule PhoenixDemo.Categories do
  import Ecto.Query

  alias PhoenixDemo.Repo
  alias PhoenixDemo.Schemas.Categories

  def list_categories() do
    query =
      from(categories in Categories, order_by: [asc: :name])

    Repo.all(query)
  end
end
