defmodule Support.Router do
  use Phoenix.Router

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :public_api do
    plug :accepts, ["json"]
    plug Conductor.Plugs.SkipAuthorization
  end

  scope "/api", Support do
    pipe_through :api

    resources "/example", ExampleController, singleton: true, only: [:create, :update, :delete]
    patch "/example/update_all", ExampleController, :update_all
  end

  scope "/api", Support do
    pipe_through :public_api

    resources "/example", ExampleController, singleton: true, only: [:show]
  end
end
