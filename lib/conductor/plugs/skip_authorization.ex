defmodule Conductor.Plugs.SkipAuthorization do
  @behaviour Plug

  def init(opts), do: opts

  def call(%Plug.Conn{} = conn, _opts) do
    conn
    |> Plug.Conn.assign(:conductor_skip_authorization, true)
  end
end
