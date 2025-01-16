defmodule PhoenixDemo.Schemas.Order do
  use Ecto.Schema
  import Ecto.Changeset
  alias PhoenixDemo.Store.User

  schema "orders" do
    field :order_number, :binary_id
    field :stripe_id, :string
    field :status, :string, default: "processing"
    field :shipping_amount, :decimal
    field :total_amount, :decimal
    field :product_list, {:array, :map}
    field :order_info, :map
    field :date, :utc_datetime
    field :tracking_number, :string

    # Relationships
    belongs_to :user, User
    timestamps()
  end

  def changeset(order, attrs) do
    order
    |> cast(attrs, [
      :order_number,
      :status,
      :shipping_amount,
      :product_list,
      :order_info,
      :total_amount,
      :user_id,
      :date,
      :stripe_id,
      :tracking_number
    ])
    |> validate_required([
      :order_number,
      :status,
      :shipping_amount,
      :total_amount,
      :product_list,
      :user_id,
      :date,
      :stripe_id
    ])
    |> validate_inclusion(:status, ~w(processing shipped delivered cancelled))
    |> unique_constraint([:order_number, :stripe_id])
    |> validate_number(:shipping_amount, greater_than_or_equal_to: 0)
    |> validate_number(:total_amount, greater_than_or_equal_to: 0)
  end

  def update_changeset(order, attrs, _metadata \\ []) do
    changeset(order, attrs)
  end

  def create_changeset(order, attrs, _metadata \\ []) do
    changeset(order, attrs)
  end
end
