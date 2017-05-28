use Mix.Config

config :conductor,
  root_scopes: ["root"],
  on_auth_failure: :send_resp

config :logger,
  level: :warn
