defmodule GabrielPoca.Images do
  use Still.Preprocessor

  alias Still.Compiler.TemplateHelpers.ResponsiveImage

  import Still.Utils

  @impl true
  def render(
        %{
          input_file: input_file,
          output_file: output_file,
          content: content
        } = source_file
      ) do
    if String.ends_with?(output_file, ".html") do
      {:ok, document} = Floki.parse_document(content)

      new_content =
        document
        |> Floki.find_and_update("img", fn
          {"img", attrs} = el ->
            src = find_attr(attrs, "src")
            srcset = find_attr(attrs, "srcset")

            if (String.ends_with?(src, "png") || String.ends_with?(src, "jpeg") ||
                  String.ends_with?(src, "jpg")) && is_nil(srcset) do
              add_srcset(input_file, attrs)
            else
              el
            end

          other ->
            other
        end)
        |> Floki.raw_html()

      %{source_file | content: new_content}
    else
      source_file
    end
  end

  defp add_srcset(input_file, img_attrs) do
    img_html =
      input_file
      |> Path.dirname()
      |> Path.join(find_attr(img_attrs, "src"))
      |> Path.expand(get_input_path())
      |> get_relative_input_path()
      |> ResponsiveImage.render()

    [src] =
      img_html
      |> Floki.attribute("img", "src")

    [srcset] =
      img_html
      |> Floki.attribute("img", "srcset")

    {"img",
     img_attrs
     |> Enum.map(fn
       {"src", _} -> {"src", src}
       other -> other
     end)
     |> Enum.concat([{"srcset", srcset}])}
  end

  defp find_attr(attrs, attr) do
    attrs
    |> Enum.find(fn {key, _} -> key == attr end)
    |> case do
      {_, val} -> val
      _ -> nil
    end
  end
end
