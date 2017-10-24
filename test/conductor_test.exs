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

    test "PATCH update", %{conn: conn} do
      conn = patch conn, example_path(conn, :update)

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

    test "PATCH update", %{conn: conn} do
      conn = patch conn, example_path(conn, :update)

      assert response(conn, 403)
    end

    test "DELETE delete", %{conn: conn} do
      conn = delete conn, example_path(conn, :delete)

      assert response(conn, 403)
    end
  end

  describe "conn with one of root scopes" do
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

    test "PATCH update", %{conn: conn} do
      conn = patch conn, example_path(conn, :update)

      assert response(conn, 200)
    end

    test "DELETE delete", %{conn: conn} do
      conn = delete conn, example_path(conn, :delete)

      assert response(conn, 200)
    end
  end

  describe "multiscopes support" do
    test "PATCH update with `update1` scope", %{conn: conn} do
      conn = conn |> Plug.Conn.assign(:scopes, ["update1"])
      conn = patch conn, example_path(conn, :update)

      assert response(conn, 200)
    end

    test "PATCH update with `update2` scope", %{conn: conn} do
      conn = conn |> Plug.Conn.assign(:scopes, ["update2"])
      conn = patch conn, example_path(conn, :update)

      assert response(conn, 200)
    end
  end

  describe "custom failure response" do
    test "custom status code", %{conn: conn} do
      Application.put_env(:conductor, :failure_status, 418)
      conn = post conn, example_path(conn, :create)

      assert response(conn, 418)
      Application.delete_env(:conductor, :failure_status)
    end
  end
end
