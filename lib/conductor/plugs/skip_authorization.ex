defmodule Conductor.Plugs.SkipAuthorization do
  @moduledoc """
    Add this plug wherever you need to disable authorization.

    ```elixir
    pipeline :skip_authorization do
      plug Conductor.Plugs.SkipAuthorization
    end

    scope "/public" do
      pipe_through [:skip_authorization]

      #...
    end
    ```
  """

  @behaviour Plug

  def init(opts), do: opts

  def call(%Plug.Conn{} = conn, _opts) do
    conn
    |> Plug.Conn.assign(:conductor_skip_authorization, true)
  end
end
