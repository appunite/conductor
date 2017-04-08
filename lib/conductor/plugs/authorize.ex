defmodule Conductor.Plugs.Authorize do
  @behaviour Plug

  def init(scope), do: scope

  def call(%Plug.Conn{assigns: %{conductor_skip_authorization: true}} = conn, _scope), do: conn
  def call(%Plug.Conn{} = conn, scope) do
    root_scope = Application.get_env(:conductor, :root_scope)

    authorized_scopes = Enum.reject([scope, root_scope], &is_nil/1)
    given_scopes = Map.get(conn.assigns, :scopes, [])

    if Enum.any?(given_scopes, &(&1 in authorized_scopes)) do
      conn
    else
      conn
      |> Plug.Conn.send_resp(403, "")
      |> Plug.Conn.halt()
    end
  end
end
