defmodule GabrielPoca.MixProject do
  use Mix.Project

  def project do
    [
      app: :gabrielpoca,
      version: "0.1.0",
      elixir: "~> 1.10",
      start_permanent: Mix.env() == :prod,
      elixirc_paths: elixirc_paths(Mix.env()),
      deps: deps()
    ]
  end

  def application do
    [
      extra_applications: [:logger],
      mod: {GabrielPoca.Application, []}
    ]
  end

  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  defp deps do
    [
      {:still, git: "https://github.com/still-ex/still", ref: "master", override: true},
      {:still_node, "~> 0.1.0"},
      {:still_snowpack, github: "still-ex/still_snowpack"},
      {:jason, "~> 1.2"},
      {:timex, "~> 3.5"},
      {:csv, "~> 2.4"}
    ]
  end
end
