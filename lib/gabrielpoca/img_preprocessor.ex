defmodule GabrielPoca.ImgPreprocessor do
  use Still.Preprocessor

  alias Imageflow.Job

  @impl true
  def render(file) do
    input_file_path =
      file.input_file
      |> Still.Utils.get_input_path()

    output_file_path =
      file.output_file
      |> Still.Utils.get_output_path()

    {:ok, job} = Job.create()

    :ok = Job.add_input_file(job, 0, input_file_path)
    :ok = Job.add_output_buffer(job, 1)

    {:ok, response} = Job.message(job, "v0.1/execute", task_for(file))

    :ok = Job.save_output_to_file(job, 1, output_file_path)

    file
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
