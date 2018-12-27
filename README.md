# Conductor

[![Build Status](https://travis-ci.org/appunite/conductor.svg?branch=master)](https://travis-ci.org/appunite/conductor)
[![Hex.pm](https://img.shields.io/hexpm/v/conductor.svg?style=flat&colorB=6B4D90)](https://hex.pm/packages/conductor)

Simple package for **api** authorization.

## When is this package good

* when you need to restrict access to most endpoints when exposing some to third party developers
* when you don't want to spam your controllers with plugs for every action
* when you must respond according to existing permission system (e.g. scopes in jwt)

## When is this package not good

* when you need authentication
* when you need authorization for html pages
* when you need advanced permissions management system

## Installation

```elixir
def deps do
  [{:conductor, "~> 0.2.0"}]
end
```

## Conductor macro

Basically, this:

```elixir
defmodule Controller do
  use Conductor # Important! It needs to be before use Phoenix.Controller
  use Phoenix.Controller

  def index(conn, _params),  do: #...

  def show(conn, _params),   do: #...

  @authorize scope: "scope1"
  def create(conn, _params), do: #...

  @authorize scope: {"scope1", "scope2"}
  def update(conn, _params), do: #... 

  @authorize scope: "scope2"
  def delete(conn, _params), do: #...
end
```

will be compiled to this:

```elixir
defmodule Controller do
  use Conductor
  use Phoenix.Controller

  plug Conductor.Plugs.Authorize, ["scope1"] when action in [:create]
  plug Conductor.Plugs.Authorize, [{"scope1", "scope2"}] when action in [:update]
  plug Conductor.Plugs.Authorize, ["scope2"] when action in [:delete]
  plug Conductor.Plugs.Authorize, [] when not action in [:create, :update, :delete]

  def index(conn, _params),  do: #...
  def show(conn, _params),   do: #...
  def create(conn, _params), do: #...
  def update(conn, _params), do: #... 
  def delete(conn, _params), do: #...
end
```

## Root scope

You can register scope that will have full access everywhere

```elixir
  config :conductor,
    root_scopes: ["admin"]
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
    root_scopes: ["root_scope"],
    on_auth_failure: :send_resp

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
  conn4 = conn1 |> Plug.Conn.assign(:scopes, ["scope1"])

  #endpoints
  @authorize scope: "scope1"
  def action1(conn, _params), do: conn |> send_resp(200, "")

  @authorize scope: "scope2"
  def action2(conn, _params), do: conn |> send_resp(200, "")

  def action3(conn, _params), do: conn |> send_resp(200, "")

  @authorize scopes: ["other", "unused"]
  def action4(conn, _params), do: conn |> send_resp(200, "")

  @authorize scope: {"scope1", "scope2}
  def action5(conn, _params), do: conn |> send_resp(200, "")
```

|         | conn1 | conn2 | conn3 | conn4 |
|---------| :---: | :---: | :---: | :---: |
| action1 | 403   | 200   | 200   | 200   |
| action2 | 200   | 200   | 200   | 200   |
| action3 | 403   | 403   | 200   | 403   |
| action4 | 403   | 403   | 200   | 403   |
| action5 | 403   | 200   | 200   | 403   |

## Customization

### Global

* Failure response status code

  ```elixir
    # config/config.exs
    config :conductor, :failure_status, 418
  ```

* Failure response body

  ```elixir
    # view
    defmodule MyApp.Web.ExampleView do
      use MyApp.Web, :view

      def render("403.json", _assigns) do
        %{message: "Forbidden"}
      end
    end

    # config/config.exs
    config :conductor, :failure_template, {MyApp.Web.ExampleView, "403.json"}
  ```

## License

Copyright 2017 Tobiasz Małecki <tobiasz.malecki@appunite.com>

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

<http://www.apache.org/licenses/LICENSE-2.0>

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
