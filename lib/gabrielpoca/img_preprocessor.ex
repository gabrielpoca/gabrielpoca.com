defmodule GabrielPoca.ImgPreprocessor do
  use Still.Preprocessor

  alias Imageflow.Graph

  @impl true
  def render(file) do
    IO.inspect(file)

    input_file_path =
      file.input_file
      |> Still.Utils.get_input_path()

    output_file_path =
      file.output_file
      |> Still.Utils.get_output_path()

    Graph.new()
    |> Graph.decode_file(input_file_path)
    |> Graph.color_filter("grayscale_bt709")
    |> Graph.encode_to_file(output_file_path)
    |> Graph.run()

    file
  end

  defp apply_metadata(graph, image_processing) do
  end

  defp task_for(%{input_file: input_file}) do
    cond do
      String.ends_with?(input_file, "bg.jpg") ->
        %{
          framewise: %{
            steps: [
              %{
                decode: %{
                  io_id: 0
                }
              },
              %{
                color_filter_srgb: "grayscale_bt709"
              },
              %{
                encode: %{
                  io_id: 1,
                  preset: %{
                    pngquant: %{"quality" => 80}
                  }
                }
              }
            ]
          }
        }

      true ->
        %{
          framewise: %{
            steps: [
              %{
                decode: %{
                  io_id: 0
                }
              },
              %{
                encode: %{
                  io_id: 1,
                  preset: %{
                    pngquant: %{"quality" => 80}
                  }
                }
              }
            ]
          }
        }
    end
  end
end
