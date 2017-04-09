use Mix.Config

config :conductor,
  root_scope: "root",
  on_auth_failure: :send_resp

config :logger,
  level: :warn
