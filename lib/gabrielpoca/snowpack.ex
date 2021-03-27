defmodule GabrielPoca.Snowpack do
  use GenServer

  def start_link(_) do
    GenServer.start_link(__MODULE__, %{}, name: __MODULE__)
  end

  def build do
    GenServer.call(__MODULE__, :build, :infinity)
  end

  def init(_) do
    {:ok, %{}, {:continue, :start}}
  end

  def handle_continue(:start, state) do
    if Mix.env() == :prod do
      Still.Compiler.CompilationStage.on_compile(&__MODULE__.build/0)
    else
      {:ok, _} = GabrielPoca.NodeProcess.invoke("start", [configuration()])
    end

    {:noreply, state}
  end

  def handle_call(:build, _from, %{build: build} = state) do
    {:reply, build, state}
  end

  def handle_call(:build, _from, state) do
    {:ok, manifest} = GabrielPoca.NodeProcess.invoke("build", [configuration()])

    {:reply, manifest, state}
  end

  defp configuration do
    %{
      inputPath: input_path(),
      outputPath: output_path()
    }
  end

  defp input_path do
    File.cwd!() |> Path.join("assets")
  end

  defp output_path do
    Still.Utils.get_output_path("assets")
  end
end
