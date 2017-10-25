defmodule Conductor.Mixfile do
  use Mix.Project

  @version "0.2.1"

  def project do
    [
      app: :conductor,
      compilers: compilers(Mix.env),
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

  defp compilers(:test), do: [:phoenix] ++ Mix.compilers
  defp compilers(_), do: Mix.compilers

  defp deps do
    [
      {:phoenix, "~> 1.1"},

      #dev & test
      {:ex_doc,  "~> 0.13",   only: :dev},
    ]
  end

  defp description do
    "Simple package for api authorization."
  end

  defp docs do
    [
      extras: ["README.md", "CHANGELOG.md"],
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
      links: %{"GitHub" => "https://github.com/appunite/conductor"}
    ]
  end
end
