defmodule PhoenixDemoWeb.Admin.UsersLive do
  use Backpex.LiveResource,
    adapter: Backpex.Adapters.Ecto,
    adapter_config: [
      schema: PhoenixDemo.Store.User,
      repo: PhoenixDemo.Repo,
      update_changeset: &PhoenixDemo.Store.User.email_changeset/3,
      create_changeset: &PhoenixDemo.Store.User.registration_changeset/3
    ],
    layout: {PhoenixDemoWeb.Layouts, :admin},
    pubsub: [
      name: PhoenixDemo.PubSub,
      topic: "users",
      event_prefix: "user_"
    ]

  @impl Backpex.LiveResource
  def singular_name, do: "User"

  @impl Backpex.LiveResource
  def plural_name, do: "Users"

  @impl Backpex.LiveResource
  def fields do
    [
      email: %{
        module: Backpex.Fields.Text,
        label: "Email",
        readonly: true
      }
    ]
  end
end
