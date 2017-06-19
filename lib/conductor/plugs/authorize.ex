defmodule Conductor.Plugs.Authorize do
  @moduledoc """
    Plug added to controllers by Conductor macro

    It takes list of scopes as option, concatenates it with list of
    root scopes and check assings inside conn.

    If at least one scope from conn is on list of authorized scopes then
    action can be performed. Otherwise it will respond according to
    choosen failure strategy (default: raise `Conductor.Error`)
  """

  @behaviour Plug

  def init(scopes), do: scopes

  def call(%Plug.Conn{assigns: %{conductor_skip_authorization: true}} = conn, _scope), do: conn
  def call(%Plug.Conn{} = conn, scopes) do
    root_scopes = Application.get_env(:conductor, :root_scopes, [])

    authorized_scopes = scopes ++ root_scopes
    given_scopes = Map.get(conn.assigns, :scopes, [])

    cond do
      Enum.any?(given_scopes, &(&1 in authorized_scopes)) ->
        conn
      Application.get_env(:conductor, :on_auth_failure) == :send_resp ->
        conn
        |> Plug.Conn.send_resp(403, "")
        |> Plug.Conn.halt()
      :else ->
        raise Conductor.Error.new(403, "")
    end
  end
end
