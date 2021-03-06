# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

# Configures the endpoint
config :gametime, GametimeWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "2wjFhse5c5SUGsoo8ryLK8l4erSPcyFcq0qpk3qezvcEF6XJJhGh1HxhhghFX31a",
  render_errors: [view: GametimeWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Gametime.PubSub, adapter: Phoenix.PubSub.PG2],
  live_view: [
    signing_salt: "jtzRjRXhBJC8220WfLACYcfZC7wumlMl"
  ]

config :gametime, cassettes: %{
  "example" => [module: Game.Example, display_name: "Example Game"],
  "civwars" => [module: Civwars, display_name: "Civwars", template: "civwars.html"]
}

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
