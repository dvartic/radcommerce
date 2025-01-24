defmodule PhoenixDemoWeb.Api.WebhookController do
  use PhoenixDemoWeb, :controller

  require Logger

  alias PhoenixDemo.Orders

  def create_order(conn, _params) do
    # Default empty string to avoid crash
    stripe_sig = get_req_header(conn, "stripe-signature") |> List.first("")

    raw_body = conn.assigns[:raw_body]

    case Stripe.Webhook.construct_event(
           raw_body,
           stripe_sig,
           Application.get_env(:phoenix_demo, :stripe_webhook_secret)
         ) do
      {:ok,
       %Stripe.Event{
         type: "checkout.session.completed",
         data: %{object: %Stripe.Checkout.Session{metadata: %{"user_id" => user_id}}}
       } =
           event} ->
        # Handle the webhook event
        session = event.data.object

        {pay_int_status, payment_intent} = Stripe.PaymentIntent.retrieve(session.payment_intent)

        {line_items_status, line_items_obj} =
          Stripe.Checkout.Session.list_line_items(session.id, %{limit: 100},
            expand: ["data.price.product"]
          )

        product_list = line_items_obj.data

        date =
          case DateTime.from_unix(event.created) do
            {:ok, date} -> DateTime.truncate(date, :second)
            {:error, _} -> DateTime.utc_now(:second)
          end

        # Write to DB
        Orders.create_order(%{
          order_number: Ecto.UUID.generate(),
          stripe_id: session.payment_intent,
          status: "processing",
          shipping_amount: 0,
          total_amount: session.amount_total,
          date: date,
          product_list:
            if(line_items_status == :ok,
              do:
                Enum.map(product_list, fn item ->
                  %{
                    price: item.amount_total,
                    unit_amount: item.price.unit_amount,
                    subtotal: item.amount_subtotal,
                    currency: item.currency,
                    name: item.price.product.name || item.description,
                    stripe_id: item.id,
                    quantity: item.quantity,
                    stripe_price_id: item.price.id,
                    stripe_product_id: item.price.product.id,
                    description: item.price.product.description,
                    images: item.price.product.images,
                    original_url: item.price.product.metadata["original_url"],
                    properties: Map.drop(item.price.product.metadata, ["original_url"])
                  }
                end),
              else: []
            ),
          order_info: %{
            customer_details: session.customer_details,
            shipping_details: if(pay_int_status == :ok, do: payment_intent.shipping, else: %{})
          },
          user_id: user_id
        })

        conn
        |> put_status(:ok)
        |> json(%{received: true})

      {:error, error} ->
        Logger.error("Error storing order using webhook, details: #{inspect(error)}")

        conn
        |> put_status(:bad_request)
        |> json(%{error: error})

      _ ->
        conn
        |> put_status(:ok)
        |> json(%{received: false})
    end
  end
end
