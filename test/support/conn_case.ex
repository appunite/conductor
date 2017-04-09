defmodule Support.ConnCase do
  use ExUnit.CaseTemplate

  using do
    quote do
      use Phoenix.ConnTest
      import Support.Router.Helpers

      @endpoint Support.Endpoint
    end
  end

  setup _tags do
    :ets.new(Support.Endpoint, [:set, :protected, :named_table, read_concurrency: true])
    :ets.insert_new(Support.Endpoint, {:secret_key_base, "test"})

    {:ok, conn: Phoenix.ConnTest.build_conn()}
  end
end
