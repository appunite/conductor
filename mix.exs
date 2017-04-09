defmodule Conductor.Mixfile do
  use Mix.Project

  @version "0.1.0"

  def project do
    [
      app: :conductor,
      deps: deps(),
      elixir: "~> 1.4",
      elixirc_paths: elixirc_paths(Mix.env),
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
      {:plug, "~> 1.0"},

      {:phoenix, "~> 1.1", only: :test}
    ]
  end

  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_),     do: ["lib"]
end
