defmodule Conductor.Mixfile do
  use Mix.Project

  @version "0.1.0"

  def project do
    [
      app: :conductor,
      deps: deps(),
      description: description(),
      docs: docs(),
      elixir: "~> 1.4",
      elixirc_paths: elixirc_paths(Mix.env),
      package: package(),
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

      #dev & test
      {:ex_doc,  "~> 0.13",   only: :dev},
      {:phoenix, "~> 1.1",    only: :test}
    ]
  end

  defp description do
    "Simple package for authorization."
  end

  defp docs do
    [
      extras: ["README.md"],
      main: "readme"
    ]
  end

  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_),     do: ["lib"]

  defp package do
    [
      name: :conductor,
      files: ~w(lib mix.exs README.md LICENSE),
      maintainers: ["Tobiasz Małecki"],
      licenses: ["Apache 2.0"],
      links: %{"GitHub" => "https://github.com/amatalai/conductor"}
    ]
  end
end
