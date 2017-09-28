use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :ex_api, ExApiWeb.Endpoint,
  http: [port: 4001],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

#Configure mailer
config :ex_api, ExApi.Mailer,
  adapter: Bamboo.TestAdapter

# Configure your database
config :ex_api, ExApi.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "predrag",
  password: "djaps94",
  database: "ex_api_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox
