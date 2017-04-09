defmodule ConductorTest do
  use Support.ConnCase

  describe "conn without any scope" do
    test "GET show", %{conn: conn} do
      conn = get conn, example_path(conn, :show)

      assert response(conn, 200)
    end

    test "POST create", %{conn: conn} do
      conn = post conn, example_path(conn, :create)

      assert response(conn, 403)
    end

    test "DELETE delete", %{conn: conn} do
      conn = delete conn, example_path(conn, :delete)

      assert response(conn, 403)
    end
  end

  describe "conn with create scope" do
    setup %{conn: conn} do
      conn = conn |> Plug.Conn.assign(:scopes, ["create"])

      {:ok, conn: conn}
    end

    test "GET show", %{conn: conn} do
      conn = get conn, example_path(conn, :show)

      assert response(conn, 200)
    end

    test "POST create", %{conn: conn} do
      conn = post conn, example_path(conn, :create)

      assert response(conn, 201)
    end

    test "DELETE delete", %{conn: conn} do
      conn = delete conn, example_path(conn, :delete)

      assert response(conn, 403)
    end
  end

  describe "conn with root scope" do
    setup %{conn: conn} do
      conn = conn |> Plug.Conn.assign(:scopes, ["root"])

      {:ok, conn: conn}
    end

    test "GET show", %{conn: conn} do
      conn = get conn, example_path(conn, :show)

      assert response(conn, 200)
    end

    test "POST create", %{conn: conn} do
      conn = post conn, example_path(conn, :create)

      assert response(conn, 201)
    end

    test "DELETE delete", %{conn: conn} do
      conn = delete conn, example_path(conn, :delete)

      assert response(conn, 200)
    end
  end
end
