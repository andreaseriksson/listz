# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :listz,
  ecto_repos: [Listz.Repo]

# Configures the endpoint
config :listz, ListzWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "oQqowfRm1/s2TYRsspXB5MYa6VEhB7pp5eXdJm9o3UmNu9dLv/HNJ6GpHXPKYIye",
  render_errors: [view: ListzWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Listz.PubSub, adapter: Phoenix.PubSub.PG2],
  live_view: [
    signing_salt: "AWUa5/TBYM/kraorgFPZk7GhQfLX2GFY"
  ]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Configuration for POW authentication
config :listz, :pow,
  user: Listz.Users.User,
  repo: Listz.Repo,
  web_module: ListzWeb,
  controller_callbacks: ListzWeb.ControllerCallbacks

config :arc,
  storage: Arc.Storage.S3,
  bucket: System.get_env("AWS_BUCKET_NAME")

config :ex_aws,
  access_key_id: System.get_env("AWS_ACCESS_KEY_ID"),
  secret_access_key: System.get_env("AWS_SECRET_ACCESS_KEY"),
  region: System.get_env("AWS_REGION")

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
