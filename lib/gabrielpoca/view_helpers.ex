defmodule GabrielPoca.ViewHelpers do
  def sort_posts(posts) do
    posts |> Enum.sort_by(& &1[:metadata][:date]) |> Enum.reverse()
  end

  def pub_date(date) do
    date
    |> Timex.parse!("{YYYY}-{0M}-{D}")
    |> Timex.format!("%a, %e %b %Y 00:00:00 GMT", :strftime)
  end

  def code_highlight(do: markup) do
    Regex.run(~r/```([^\n]*)\n/, markup, capture: :all_but_first)
    |> case do
      [] ->
        markup

      [lang] ->
        code_markup =
          markup
          |> String.trim()
          |> String.replace_leading("```#{lang}", "")
          |> String.replace_suffix("```", "")
          |> String.trim()

        {:ok, new_markup} = NodeJS.call({"index", :highlight}, [lang, code_markup])
        "<pre><code>#{new_markup}</code></pre>"
    end
  end

  def highlight_styles do
    {:ok, styles} = NodeJS.call({"index", :highlight_styles}, [])

    styles
  end
end
