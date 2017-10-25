defmodule Support.ExampleView do
  use Phoenix.View, root: "test/support/templates"

  def render("403.json", _assigns) do
    %{message: "Forbidden"}
  end
end
