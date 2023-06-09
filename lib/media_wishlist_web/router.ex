defmodule MediaWishlistWeb.Router do
  use MediaWishlistWeb, :router

  import MediaWishlistWeb.UserAuth

  pipeline :browser do
    plug(:accepts, ["html"])
    plug(:fetch_session)
    plug(:fetch_live_flash)
    plug(:put_root_layout, {MediaWishlistWeb.Layouts, :root})
    plug(:protect_from_forgery)
    plug(:put_secure_browser_headers)
    plug(:fetch_current_user)
  end

  pipeline :api do
    plug(:accepts, ["json"])
  end

  scope "/", MediaWishlistWeb do
    pipe_through(:browser)

    get("/", PageController, :home)
  end

  # Other scopes may use custom stacks.
  # scope "/api", MediaWishlistWeb do
  #   pipe_through :api
  # end

  ## Authentication routes

  scope "/", MediaWishlistWeb do
    pipe_through([:browser, :redirect_if_user_is_authenticated])

    live_session :redirect_if_user_is_authenticated,
      on_mount: [{MediaWishlistWeb.UserAuth, :redirect_if_user_is_authenticated}] do
      live("/users/register", UserRegistrationLive, :new)
      live("/users/log_in", UserLoginLive, :new)
      live("/users/reset_password", UserForgotPasswordLive, :new)
      live("/users/reset_password/:token", UserResetPasswordLive, :edit)
    end

    post("/users/log_in", UserSessionController, :create)
  end

  scope "/", MediaWishlistWeb do
    pipe_through([:browser, :require_authenticated_user])

    live_session :require_authenticated_user,
      on_mount: [{MediaWishlistWeb.UserAuth, :ensure_authenticated}] do
      live("/users/settings", UserSettingsLive, :edit)
      live("/users/settings/confirm_email/:token", UserSettingsLive, :confirm_email)
    end
  end

  scope "/", MediaWishlistWeb do
    pipe_through([:browser])

    delete("/users/log_out", UserSessionController, :delete)

    live_session :current_user,
      on_mount: [{MediaWishlistWeb.UserAuth, :mount_current_user}] do
      live("/users/confirm/:token", UserConfirmationLive, :edit)
      live("/users/confirm", UserConfirmationInstructionsLive, :new)
    end
  end

  scope "/wishlist", MediaWishlistWeb do
    pipe_through([:browser, :require_authenticated_user])

    post("/new", WishlistController, :new)
    get("/fetch", WishlistController, :fetch)
    delete("/:id", WishlistController, :delete)
    get("/:id", WishlistController, :game)
    get("/", WishlistController, :view)
  end

  scope "/search", MediaWishlistWeb do
    pipe_through([:browser, :require_authenticated_user])

    get("/:gameID", SearchController, :game)
    get("/", SearchController, :start)
    post("/", SearchController, :results)
  end
end
