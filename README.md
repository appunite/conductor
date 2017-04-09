# Conductor

Simple package for authorization.

## Installation

```elixir
def deps do
  [{:conductor, "~> 0.1.0"}]
end
```

## Conductor macro
Basically, this:

```elixir
defmodule Controller do
  use Conductor
  use Phoenix.Controller

  def index(conn, _params),  do: #...

  def show(conn, _params),   do: #...

  @authorize scope: "scope1"
  def create(conn, _params)  do: #...

  @authorize scope: "scope2"
  def delete(conn, _params), do: #...
end
```

will be compiled to this:

```elixir
defmodule Controller do
  use Conductor
  use Phoenix.Controller

  plug Conductor.Plugs.Authorize, "scope1" when action in [:create]
  plug Conductor.Plugs.Authorize, "scope2" when action in [:delete]
  plug Conductor.Plugs.Authorize, nil when not action in [:create, :delete]

  def index(conn, _params),  do: #...
  def show(conn, _params),   do: #...
  def create(conn, _params), do: #...
  def delete(conn, _params), do: #...
end
```

## Root scope

You can register scope that will have full access everywhere

```elixir
  config :conductor,
    root_scope: "admin"
```

## Adding scopes

```elixir
  conn |> Plug.Conn.assign(:scopes, ["scope1, scope2"])
```

## Public access

```elixir
defmodule Router do
  pipeline :public do
    plug Conductor.Plugs.SkipAuthorization
  end

  scope "/public", MyApp do
    pipe_through [:public]

    get "/something", SomethingController, :something
  end
end
```

## Authorization failures

To avoid confusion with random `403` response codes that come from nowhere, Conductor will raise error on authorization failure as default.

This can be changed by following config

```elixir
  config :conductor,
    on_auth_failure: :send_resp
```

## Example

```elixir
  #config
  config :conductor,
    root_scope: "root_scope",
    on_auth_error: :send_resp

  #router
  pipeline :public do
    plug Conductor.Plugs.SkipAuthorization
  end

  scope "/", Example do
    get "/1", Controller, :action1
    get "/3", Controller, :action3
    get "/4", Controller, :action4
  end

  scope "/", Example do
    pipe_through [:public]

    get "/2", Controller, :action2
  end

  #conns
  conn1 = Phoenix.ConnTest.build_conn()
  conn2 = conn1 |> Plug.Conn.assign(:scopes, ["scope1", "scope2"])
  conn3 = conn1 |> Plug.Conn.assign(:scopes, ["root_scope"])

  #endpoints
  @authorize scope: "scope1"
  def action1(conn, _params), do: conn |> send_resp(200, "")

  @authorize scope: "scope2"
  def action2(conn, _params), do: conn |> send_resp(200, "")

  def action3(conn, _params), do: conn |> send_resp(200, "")

  @authorize scope: "other"
  def action4(conn, _params), do: conn |> send_resp(200, "")
```

|         | conn1              | conn2              | conn3             |
|---------|--------------------|--------------------|-------------------|
| action1 | :broken_heart: 403 | :green_heart: 200  | :green_heart: 200 |
| action2 | :green_heart: 200  | :green_heart: 200  | :green_heart: 200 |
| action3 | :broken_heart: 403 | :broken_heart: 403 | :green_heart: 200 |
| action4 | :broken_heart: 403 | :broken_heart: 403 | :green_heart: 200 |
