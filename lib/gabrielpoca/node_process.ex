defmodule GabrielPoca.NodeProcess do
  use GenServer

  @js_server_path Application.app_dir(:gabrielpoca, "priv/server.js")
  @node_env if Mix.env() == :prod, do: 'production', else: 'development'
  @read_chunk_size 65_536

  require Logger

  def start_link(args) do
    GenServer.start_link(__MODULE__, args, name: __MODULE__)
  end

  def invoke(fun, args) do
    GenServer.call(__MODULE__, {:invoke, fun, args}, :infinity)
  end

  def init(args) do
    module_path = Keyword.fetch!(args, :module_path)
    file_path = Keyword.fetch!(args, :file_path)
    node = System.find_executable("node")

    port =
      Port.open(
        {:spawn_executable, node},
        line: @read_chunk_size,
        env: [
          {'NODE_ENV', @node_env},
          {'NODE_PATH', node_path(module_path)},
          {'WRITE_CHUNK_SIZE', String.to_charlist("#{@read_chunk_size}")}
        ],
        args: [@js_server_path, file_path]
      )

    {:ok, %{module_path: module_path, port: port, responses: %{}}, {:continue, :start}}
  end

  def handle_continue(:start, state) do
    {:noreply, state}
  end

  def handle_call({:invoke, fun, args}, pid, state) do
    id = "__elixirnodejs__#{:rand.uniform(999)}__"
    body = Jason.encode!([id, fun, args])
    Port.command(state.port, "#{body}\n")

    responses =
      Map.put(state.responses, id, %{
        pid: pid,
        body: ""
      })

    {:noreply, %{state | responses: responses}, :infinity}
  end

  def handle_info({_, {:data, {:eol, message}}}, state) do
    case message do
      '__elixirnodejs__' ++ _ ->
        [_, id, encoded_response] =
          Regex.run(~r/(__elixirnodejs__[\d]+__)(.*)/, message |> List.to_string())

        [success, response] =
          (state.responses[id][:body] <> encoded_response)
          |> Jason.decode!()

        pid = state.responses[id][:pid]

        if success do
          GenServer.reply(pid, {:ok, response})
        else
          GenServer.reply(pid, {:error, response})
        end

        responses = Map.drop(state.responses, [id])

        {:noreply, %{state | responses: responses}}

      message ->
        Logger.debug(message)

        {:noreply, state}
    end
  end

  def handle_info({_, {:data, {_, message}}}, state) do
    case message do
      '__elixirnodejs__' ++ _ ->
        [_, id, response] =
          Regex.run(~r/(__elixirnodejs__[\d]+__)(.*)/, message |> List.to_string())

        responses =
          Map.put(state.responses, id, %{
            state.responses[id]
            | body: state.responses[id][:body] <> response
          })

        {:noreply, %{state | responses: responses}}

      message ->
        Logger.debug(message)

        {:noreply, state}
    end
  end

  defp node_path(module_path) do
    [module_path, module_path <> "/node_modules"]
    |> Enum.join(node_path_separator())
    |> String.to_charlist()
  end

  defp node_path_separator do
    case :os.type() do
      {:win32, _} -> ";"
      _ -> ":"
    end
  end

  def terminate(reason, state) do
    Logger.error(reason)
    send(state.port, {self(), :close})
  end
end
