defmodule PhoenixDemoWeb.Router do
  import Backpex.Router
  use PhoenixDemoWeb, :router

  import PhoenixDemoWeb.UserAuth

  import PhoenixDemoWeb.AdminAuth

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    # Read cart cookie and put it in session
    plug PhoenixDemoWeb.PutCartCookie
    # Read domain and put it in session
    plug PhoenixDemoWeb.PutDomain
    # Locale
    plug PhoenixDemoWeb.Locale
    plug :put_root_layout, html: {PhoenixDemoWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug :fetch_current_user
    plug :fetch_current_admin
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  # Health Check for DevOps systems
  scope "/", PhoenixDemoWeb do
    pipe_through :browser
    # Health Check for DevOps systems
    get "/up", PageController, :health_check
  end

  scope "/", PhoenixDemoWeb do
    pipe_through :browser

    live_session :main,
      on_mount: [
        PhoenixDemoWeb.Layouts.NavParamsLoader,
        PhoenixDemoWeb.RestoreLocale,
        {PhoenixDemoWeb.UserAuth, :mount_current_user}
      ] do
      live "/", HomeLive, :index

      # All products
      live "/products", Products.ProductsLive, :index

      # Product pages
      live "/products/:id", Products.Product.ProductLive, :index

      # About
      live "/about", AboutLive, :index

      # Contact
      live "/contact", ContactLive, :index

      # Checkout
      live "/checkout/:id", Checkout.CheckoutLive, :index

      # Checkout Return
      live "/checkout-return/:id", Checkout.CheckoutReturnLive, :index
    end

    post "/change_language", ChangeLanguageController, :change_language
  end

  scope "/admin", PhoenixDemoWeb do
    pipe_through [:browser, :require_authenticated_admin]

    backpex_routes()

    live_session :default,
      on_mount: [
        Backpex.InitAssigns,
        {PhoenixDemoWeb.AdminAuth, :ensure_authenticated}
      ] do
      live_resources("/products", Admin.ProductsLive)
      live_resources("/categories", Admin.CategoriesLive)
      live_resources("/text-contents", Admin.TextContentsLive)
      live_resources("/languages", Admin.LanguagesLive)
      live_resources("/translations", Admin.TranslationsLive)
      live_resources("/orders", Admin.OrdersLive)
      live_resources("/users", Admin.UsersLive)
    end
  end

  # API Routes
  scope "/api", PhoenixDemoWeb do
    pipe_through :api

    post "/webhooks/stripe/create-order", Api.WebhookController, :create_order

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

  ## Authentication routes

  scope "/", PhoenixDemoWeb do
    pipe_through [
      :browser,
      :redirect_if_admin_is_authenticated
    ]

    live_session :redirect_if_admin_is_authenticated,
      on_mount: [
        {PhoenixDemoWeb.AdminAuth, :redirect_if_admin_is_authenticated},
        PhoenixDemoWeb.Layouts.NavParamsLoader
      ] do
      live "/admins/log_in", AdminLoginLive, :new
      live "/admins/reset_password", AdminForgotPasswordLive, :new
      live "/admins/reset_password/:token", AdminResetPasswordLive, :edit
    end

    post "/admins/log_in", AdminSessionController, :create
  end

  # Only allow admin creation if none exists
  scope "/", PhoenixDemoWeb do
    pipe_through [
      :browser,
      :redirect_if_admin_is_authenticated,
      :only_allow_if_none_exists
    ]

    live_session :only_allow_if_none_exists,
      on_mount: [
        {PhoenixDemoWeb.AdminAuth, :redirect_if_admin_is_authenticated},
        {PhoenixDemoWeb.AdminAuth, :only_allow_if_none_exists},
        PhoenixDemoWeb.Layouts.NavParamsLoader
      ] do
      live "/admins/register", AdminRegistrationLive, :new
    end
  end

  scope "/", PhoenixDemoWeb do
    pipe_through [:browser, :require_authenticated_admin]

    live_session :require_authenticated_admin,
      on_mount: [
        {PhoenixDemoWeb.AdminAuth, :ensure_authenticated},
        PhoenixDemoWeb.Layouts.NavParamsLoader
      ] do
      live "/admins/settings", AdminSettingsLive, :edit
      live "/admins/settings/confirm_email/:token", AdminSettingsLive, :confirm_email
    end
  end

  scope "/", PhoenixDemoWeb do
    pipe_through [:browser]

    delete "/admins/log_out", AdminSessionController, :delete

    live_session :current_admin,
      on_mount: [
        {PhoenixDemoWeb.AdminAuth, :mount_current_admin},
        PhoenixDemoWeb.Layouts.NavParamsLoader
      ] do
      live "/admins/confirm/:token", AdminConfirmationLive, :edit
      live "/admins/confirm", AdminConfirmationInstructionsLive, :new
    end
  end

  ## Authentication routes

  scope "/", PhoenixDemoWeb do
    pipe_through [:browser, :redirect_if_user_is_authenticated]

    live_session :redirect_if_user_is_authenticated,
      on_mount: [
        {PhoenixDemoWeb.UserAuth, :redirect_if_user_is_authenticated},
        PhoenixDemoWeb.Layouts.NavParamsLoader,
        PhoenixDemoWeb.RestoreLocale
      ] do
      live "/users/register", UserRegistrationLive, :new
      live "/users/log_in", UserLoginLive, :new
      live "/users/reset_password", UserForgotPasswordLive, :new
      live "/users/reset_password/:token", UserResetPasswordLive, :edit
    end

    post "/users/log_in", UserSessionController, :create
  end

  scope "/", PhoenixDemoWeb do
    pipe_through [:browser, :require_authenticated_user]

    live_session :require_authenticated_user,
      on_mount: [
        {PhoenixDemoWeb.UserAuth, :ensure_authenticated},
        PhoenixDemoWeb.Layouts.NavParamsLoader,
        PhoenixDemoWeb.RestoreLocale
      ] do
      live "/users/settings", UserSettingsLive, :edit
      live "/users/settings/confirm_email/:token", UserSettingsLive, :confirm_email
      live "/users/orders", User.UserOrdersLive, :index
      live "/users/orders/:order_number", User.Orders.Order.OrderLive, :index
    end
  end

  scope "/", PhoenixDemoWeb do
    pipe_through [:browser]

    delete "/users/log_out", UserSessionController, :delete

    live_session :current_user,
      on_mount: [
        {PhoenixDemoWeb.UserAuth, :mount_current_user},
        PhoenixDemoWeb.Layouts.NavParamsLoader,
        PhoenixDemoWeb.RestoreLocale
      ] do
      live "/users/confirm/:token", UserConfirmationLive, :edit
      live "/users/confirm", UserConfirmationInstructionsLive, :new
    end
  end
end
