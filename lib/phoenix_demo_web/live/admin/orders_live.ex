defmodule PhoenixDemoWeb.Admin.OrdersLive do
  use Backpex.LiveResource,
    adapter: Backpex.Adapters.Ecto,
    adapter_config: [
      schema: PhoenixDemo.Schemas.Order,
      repo: PhoenixDemo.Repo,
      update_changeset: &PhoenixDemo.Schemas.Order.update_changeset/3,
      create_changeset: &PhoenixDemo.Schemas.Order.create_changeset/3
    ],
    layout: {PhoenixDemoWeb.Layouts, :admin},
    pubsub: [
      name: PhoenixDemo.PubSub,
      topic: "orders",
      event_prefix: "order_"
    ]

  @impl Backpex.LiveResource
  def singular_name, do: "Order"

  @impl Backpex.LiveResource
  def plural_name, do: "Orders"

  @impl Backpex.LiveResource
  def fields do
    [
      date: %{
        module: Backpex.Fields.Date,
        label: "Date",
        readonly: true
      },
      status: %{
        module: Backpex.Fields.Select,
        label: "Status",
        options: ["processing", "shipped", "delivered", "cancelled"]
      },
      tracking_number: %{
        module: Backpex.Fields.Text,
        label: "Tracking Number"
      },
      shipping_amount: %{
        module: Backpex.Fields.Number,
        label: "Shipping Amount"
      },
      total_amount: %{
        module: Backpex.Fields.Number,
        label: "Total Amount"
      },
      # product_list: %{
      #   module: Backpex.Fields.Textarea,
      #   label: "Product List"
      # },
      # order_info: %{
      #   module: Backpex.Fields.Textarea,
      #   label: "Order Info"
      # },
      order_number: %{
        module: Backpex.Fields.Text,
        label: "Order Number",
        readonly: true
      },
      stripe_id: %{
        module: Backpex.Fields.Text,
        label: "Order Number",
        readonly: true
      },
      user: %{
        module: Backpex.Fields.BelongsTo,
        label: "User",
        display_field: :email,
        live_resource: PhoenixDemoWeb.Admin.UsersLive
      }
    ]
  end
end
