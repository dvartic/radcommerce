defmodule PhoenixDemo.Orders do
  alias PhoenixDemo.Repo
  alias PhoenixDemo.Schemas.Order
  import Ecto.Query

  def get_orders_by_user(user_id) do
    Order
    |> where([o], o.user_id == ^user_id)
    |> order_by([o], fragment("? DESC NULLS LAST", o.date))
    |> Repo.all()
  end

  def get_order_by_order_number_and_check_user_auth(order_number, user_id) do
    Order
    |> where([o], o.order_number == ^order_number and o.user_id == ^user_id)
    |> Repo.one()
  end

  def create_order(attrs) do
    %Order{}
    |> Order.changeset(attrs)
    |> Repo.insert(
      on_conflict: :nothing,
      conflict_target: :id
    )
  end
end
