defmodule Support.ExampleController do
  use Conductor
  use Phoenix.Controller

  def show(conn, _params) do
    conn |> send_resp(200, "")
  end

  @authorize scope: "create"
  def create(conn, _params) do
    conn |> send_resp(201, "")
  end

  def delete(conn, _params) do
    conn |> send_resp(200, "")
  end
end
