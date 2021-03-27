defmodule GabrielPoca.Application do
  use Application

  @js_path Path.dirname(__DIR__) |> Path.join("../assets/") |> Path.expand()
  @js_file_path Path.dirname(__DIR__) |> Path.join("../assets/snowpack.js") |> Path.expand()

  def start(_type, _args) do
    children = [
      {GabrielPoca.NodeProcess, [module_path: @js_path, file_path: @js_file_path]},
      GabrielPoca.Snowpack
    ]

    opts = [strategy: :one_for_one, name: Still.NodeJS.Supervisor]

    Supervisor.start_link(children, opts)
  end
end
