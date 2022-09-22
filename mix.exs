defmodule GabrielPoca.MixProject do
  use Mix.Project

  def project do
    [
      app: :gabrielpoca,
      version: "0.1.0",
      elixir: "~> 1.12",
      start_permanent: Mix.env() == :prod,
      elixirc_paths: elixirc_paths(Mix.env()),
      deps: deps()
    ]
  end

  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  defp deps do
    [
      {:still,
       github: "still-ex/still", ref: "ce8d3fd6bacf4a4108bc85adb5cc5e177d8393d5", override: true},
      # {:still, path: "../still", override: true},
      # {:still, "~> 0.7"},
      {:jason, "~> 1.2"},
      {:timex, "~> 3.5"},
      {:csv, "~> 2.4"},
      {:slugify, "~> 1.3"},
      {:floki, "~> 0.32.0", override: true}
    ]
  end
end
