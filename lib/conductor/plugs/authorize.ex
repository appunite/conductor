defmodule Conductor.Plugs.Authorize do
  @moduledoc """
    Plug added to controllers by Conductor macro

    It takes list of scopes as option, concatenates it with list of
    root scopes and check assings inside conn.

    If at least one scope from conn is on list of authorized scopes then
    action can be performed. Otherwise it will respond according to
    choosen failure strategy (default: raise `Conductor.Error`)

    If you would like to require multiple scopes at once, inclose them in tuple.
    For example:
    ```
    @authorize scope: {"scope1", "scope2"}
    def action(conn, _params), do: ...
    ```
    In order to perform action both "scope1" and "scope2" must be assigned inside conn.
  """

  @behaviour Plug

  def init(scopes), do: scopes

  def call(%Plug.Conn{assigns: %{conductor_skip_authorization: true}} = conn, _scope), do: conn

  def call(%Plug.Conn{} = conn, scopes) do
    root_scopes = Application.get_env(:conductor, :root_scopes, [])

    authorized_scopes = scopes ++ root_scopes
    given_scopes = Map.get(conn.assigns, :scopes, [])

    cond do
      is_authorized?(given_scopes, authorized_scopes) ->
        conn

      Application.get_env(:conductor, :on_auth_failure) == :send_resp ->
        handle_response(conn)

      :else ->
        raise Conductor.Error.new(403, "")
    end
  end

  defp is_authorized?(given_scopes, authorized_scopes) do
    Enum.any?(authorized_scopes, &has_authorized_scope(&1, given_scopes))
  end

  defp has_authorized_scope(scopes, given_scopes) when is_tuple(scopes) do
    scopes |> Tuple.to_list() |> Enum.all?(&(&1 in given_scopes))
  end

  defp has_authorized_scope(scope, given_scopes) do
    scope in given_scopes
  end

  defp handle_response(conn) do
    status = Application.get_env(:conductor, :failure_status, 403)

    case Application.get_env(:conductor, :failure_template) do
      nil ->
        conn
        |> Plug.Conn.send_resp(status, "")
        |> Plug.Conn.halt()

      {view, template} ->
        conn
        |> Plug.Conn.put_status(status)
        |> Phoenix.Controller.put_view(view)
        |> Phoenix.Controller.render(template, %{})
        |> Plug.Conn.halt()
    end
  end
end
