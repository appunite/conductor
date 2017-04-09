defmodule Support.Endpoint do
  use Phoenix.Endpoint, otp_app: :support

  plug Support.Router
end
