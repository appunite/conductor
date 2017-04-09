use Mix.Config

config :conductor,
  root_scope: "root",
  on_auth_failure: :response

config :logger,
  level: :warn
