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
  pubsub: [name: Listz.PubSub, adapter: Phoenix.PubSub.PG2]

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

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
