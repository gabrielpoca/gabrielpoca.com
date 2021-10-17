defmodule GabrielPoca.Seo do
  use Still.Preprocessor

  import Still.Utils

  @impl true
  def render(%{input_file: input_file, run_type: run_type} = source_file) do
    case String.starts_with?(input_file, "blog") and run_type != :compile_metadata do
      true -> generate_seo_image(source_file)
      _ -> source_file
    end
  end

  def generate_seo_image(%{metadata: %{title: title}} = source_file) do
    output_file = String.replace(source_file.output_file, "index.html", "seo.png")

    full_output_file = get_output_path(output_file)

    full_output_file
    |> Path.dirname()
    |> File.mkdir_p!()

    generate_file(title, full_output_file)

    new_metadata =
      source_file.metadata
      |> Map.put(
        :seo_img,
        Application.get_env(:still, :domain) <> "/" <> get_base_url() <> output_file
      )
      |> Map.put(
        :seo_url,
        Application.get_env(:still, :domain) <> "/" <> get_base_url() <> source_file.output_file
      )
      |> Map.put(:seo_description, title)

    %{source_file | metadata: new_metadata}
  end

  defp generate_file(title, file) do
    title = multiline_title(title)

    tmp = System.tmp_dir!()
    bg = "#090909"
    res = "2160x1080"

    "convert #{get_input_path("icon.png")} -resize 80x80 #{tmp}/icon.png "
    |> String.to_charlist()
    |> :os.cmd()

    # set background color
    "convert -size #{res} xc:'#{bg}' #{tmp}/bg.png"
    |> String.to_charlist()
    |> :os.cmd()

    # overlay text
    "convert -page +0+0 #{tmp}/bg.png -size #{res} xc:'#00000000' -fill '#FFCEAE' -pointsize 35 -font #{get_input_path("fonts/IBMPlexSansCondensed-Regular.ttf")} -gravity northwest -annotate +205+114 'gabrielpoca.com' -font #{get_input_path("fonts/IBMPlexSansCondensed-Bold.ttf")}  -pointsize 95 -gravity center -annotate +0+0 '#{title}' -layers merge +repage #{tmp}/bg.png"
    |> String.to_charlist()
    |> :os.cmd()

    # overlay logo
    "composite -geometry +100+100 #{tmp}/icon.png #{tmp}/bg.png #{file}"
    |> String.to_charlist()
    |> :os.cmd()
    |> IO.inspect()
  end

  defp multiline_title(title) do
    title
    |> String.split()
    |> Enum.reduce([], fn word, acc ->
      case acc do
        [] ->
          [word]

        [line | lines] ->
          new_line = line <> " #{word}"

          if String.length(new_line) > 20 do
            [word, line | lines]
          else
            [new_line | lines]
          end
      end
    end)
    |> Enum.reverse()
    |> Enum.join("\n")
  end
end
