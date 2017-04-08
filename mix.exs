defmodule Conductor.Mixfile do
  use Mix.Project

  @version "0.1.0"

  def project do
    [
      app: :conductor,
      deps: deps(),
      elixir: "~> 1.4",
      version: @version
    ]
  end

  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp deps do
    [
      {:plug, "~> 1.0"}
    ]
  end
end
