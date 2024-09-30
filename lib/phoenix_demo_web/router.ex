defmodule PhoenixDemoWeb.Router do
  import Backpex.Router
  use PhoenixDemoWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    # Read cart cookie and put it in session
    plug PhoenixDemoWeb.PutCartCookie
    # Read domain and put it in session
    plug PhoenixDemoWeb.PutDomain
    plug :put_root_layout, html: {PhoenixDemoWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", PhoenixDemoWeb do
    pipe_through :browser

    live_session :main, on_mount: [PhoenixDemoWeb.Layouts.NavParamsLoader] do
      live "/", HomeLive, :index

      # All products
      live "/products", Products.ProductsLive, :index

      # Product pages
      live "/products/:id", Products.Product.ProductLive, :index

      # About
      live "/about", AboutLive, :index

      # Checkout
      live "/checkout/:id", Checkout.CheckoutLive, :index

      # Checkout Return
      live "/checkout-return/:id", Checkout.CheckoutReturnLive, :index
    end
  end

  scope "/admin", PhoenixDemoWeb do
    pipe_through :browser

    backpex_routes()

    live_session :default, on_mount: Backpex.InitAssigns do
      live_resources("/products", Admin.ProductsLive)
      live_resources("/categories", Admin.CategoriesLive)
      live_resources("/legal-pages", Admin.LegalPagesLive)
    end
  end

  # API Routes
  scope "/api", PhoenixDemoWeb do
    pipe_through :api

    # post "/stripe/create-checkout-session", Api.StripeController, :create
    # get "/stripe/create-checkout-session", PageController, :home
  end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:phoenix_demo, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: PhoenixDemoWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
