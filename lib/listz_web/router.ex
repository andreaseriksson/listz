defmodule ListzWeb.Router do
  use ListzWeb, :router
  use Pow.Phoenix.Router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :protected do
    plug Pow.Plug.RequireAuthenticated,
      error_handler: Pow.Phoenix.PlugErrorHandler
    plug ListzWeb.Plugs.PutUserToken
  end

  scope "/" do
    pipe_through :browser

    pow_routes()
  end

  scope "/", ListzWeb do
    pipe_through [:browser, :protected]

    get "/", ListController, :index
    resources "/lists", ListController, except: [:new] do
      delete "/attachment", AttachmentController, :delete
      resources "/tasks", TaskController, only: [:create, :update, :delete]
    end
  end

  if Mix.env == :dev do
    scope "/dev" do
      pipe_through [:browser]

      forward "/mailbox", Plug.Swoosh.MailboxPreview, [base_path: "/dev/mailbox"]
    end
  end

  # Other scopes may use custom stacks.
  # scope "/api", ListzWeb do
  #   pipe_through :api
  # end
end
