defmodule Support.Endpoint do
  use Phoenix.Endpoint, otp_app: :example

  plug Plug.RequestId
  plug Plug.Logger

  plug Plug.Parsers,
    parsers: [:urlencoded, :multipart, :json],
    pass: ["*/*"],
    json_decoder: Poison

  plug Plug.MethodOverride
  plug Plug.Head
  # 
  # plug Plug.Session,
  #   store: :cookie,
  #   key: "_example_key",
  #   signing_salt: "z+HETy9J"

  plug Support.Router
end
