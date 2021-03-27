defmodule GabrielPoca.ViewHelpers do
  def import_css_file(name) do
    if Mix.env() == :prod do
      url =
        Still.Utils.get_base_url()
        |> Path.join("assets")
        |> Path.join(name)

      """
      <link rel="stylesheet" href="/#{url}" />
      """
    else
      """
      <link rel="stylesheet" href="http://localhost:3001/#{name}" />
      """
    end
  end

  def import_js_file(name) do
    if Mix.env() == :prod do
      url =
        Still.Utils.get_base_url()
        |> Path.join("assets")
        |> Path.join(name)

      """
      <script src="/#{url}" type="module"></script>
      """
    else
      """
      <script>
        window.HMR_WEBSOCKET_URL = 'ws://localhost:3002';
      </script>
      <script src="http://localhost:3001/#{name}" type="module"></script>
      """
    end
  end

  def item_files(post) do
    Map.get(post[:metadata], :files, [])
  end

  def sort_by_date(items) do
    items |> Enum.sort_by(& &1[:metadata][:date]) |> Enum.reverse()
  end

  def pub_date(date) do
    date
    |> Timex.parse!("{YYYY}-{0M}-{D}")
    |> Timex.format!("%a, %e %b %Y 00:00:00 GMT", :strftime)
  end

  def file_size(file) do
    %{size: size} = File.stat!(file)
    size
  end

  def music_item_color do
    color =
      0..360
      |> Enum.random()

    "background-color:hsl(#{color}deg 100% 91%)"
  end

  def music_item_offset do
    space =
      [0, 5, 10, 6, 2, 16, 12, 8, 4]
      |> Enum.random()

    "sm:ml-#{space}"
  end
end
