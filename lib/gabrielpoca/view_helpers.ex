defmodule GabrielPoca.ViewHelpers do
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

    "background-color:hsl(#{color}deg 100% 95%)"
  end

  def music_item_offset do
    space =
      [0, 5, 10, 6, 2, 16, 12, 8, 4]
      |> Enum.random()

    "sm:ml-#{space}"
  end

  def book_rating(%{metadata: %{rating: rating}}) when is_binary(rating) do
    Integer.parse(rating)
  end

  def book_rating(%{metadata: %{rating: rating}}) when is_nil(rating) do
    nil
  end

  def book_rating(%{metadata: %{rating: rating}}) do
    rating
  end

  def book_has_content?(%{metadata: %{has_review: has_review}}) do
    has_review
  end
end
