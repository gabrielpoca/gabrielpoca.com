defmodule GabrielPoca.Application do
  use Application

  # @js_file Application.app_dir(:gabrielpoca, "assets/index.js")
  @js_file Path.dirname(__DIR__) |> Path.join("../assets/index.js") |> Path.expand()

  def start(_type, _args) do
    children = [
      {Still.Snowpack.Supervisor, @js_file}
    ]

    opts = [strategy: :one_for_one, name: Still.NodeJS.Supervisor]

    Supervisor.start_link(children, opts)
  end
end
