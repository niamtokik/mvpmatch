# This file is responsible for configuring your application
# and its dependencies with the aid of the Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
import Config

config :mvpmatch,
  ecto_repos: [Mvpmatch.Repo],
  generators: [timestamp_type: :utc_datetime]

# Configures the endpoint
config :mvpmatch, MvpmatchWeb.Endpoint,
  url: [host: "localhost"],
  adapter: Phoenix.Endpoint.Cowboy2Adapter,
  render_errors: [
    formats: [html: MvpmatchWeb.ErrorHTML, json: MvpmatchWeb.ErrorJSON],
    layout: false
  ],
  pubsub_server: Mvpmatch.PubSub,
  live_view: [signing_salt: "bMaiZTPL"]

# Configures the mailer
#
# By default it uses the "Local" adapter which stores the emails
# locally. You can see the emails in your browser, at "/dev/mailbox".
#
# For production it's recommended to configure a different adapter
# at the `config/runtime.exs`.
config :mvpmatch, Mvpmatch.Mailer, adapter: Swoosh.Adapters.Local

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{config_env()}.exs"
