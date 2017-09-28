# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :ex_api,
  ecto_repos: [ExApi.Repo]

# Configures the endpoint
config :ex_api, ExApiWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "6Lg6wt7hbNxJDreULtHbuyYVgrwxWrAR9SuCVdJLR772/oIqxSlM7yaDqotBDnpb",
  render_errors: [view: ExApiWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: ExApi.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

#Configurates mailer
config :ex_api, ExApi.Mailer,
  adapter: Bamboo.LocalAdapter

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
