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

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  # Specifies your project dependencies.
  #
  # Type `mix help deps` for examples and options.
  defp deps do
    [
      {:still, "~> 0.1.2"},
      {:slime, "~> 1.2"},
      {:sass, git: "https://github.com/scottdavis/sass.ex", submodules: true},
      {:imageflow, "~> 0.4.0"},
      {:timex, "~> 3.5"}
    ]
  end
end
