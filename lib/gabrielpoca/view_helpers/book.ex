defmodule GabrielPoca.ViewHelpers.Book do
  alias Still.Data

  def all do
    (Data.global().books ++ Map.values(Map.get(Data.global(), :book_reviews, %{})))
    |> Enum.sort_by(& &1["author"])
    |> Enum.sort_by(& &1["dateRead"])
    |> Enum.reverse()
  end

  def all_with_reviews do
    all() |> Enum.filter(&has_review?/1)
  end

  def id(%{"isbn13" => isbn13}), do: isbn13

  def id(%{"isbn" => isbn}), do: isbn

  def id(%{"goodreads" => goodreads}), do: goodreads

  def id(_), do: nil

  def cover(%{"cover" => cover}) when not is_nil(cover), do: cover

  def cover(book) do
    %{"isbn" => isbn, "isbn13" => isbn13, "goodreads" => goodreads} = book

    cond do
      cover_file_exists?(isbn13) -> cover_file(isbn13)
      cover_file_exists?(isbn) -> cover_file(isbn)
      cover_file_exists?(goodreads) -> cover_file(goodreads)
      true -> nil
    end
  end

  def rating(%{"rating" => rating}) when is_binary(rating) do
    {rating, _} = Integer.parse(rating)
    rating
  end

  def rating(%{"rating" => rating}) when is_nil(rating) do
    nil
  end

  def rating(%{"rating" => rating}) do
    rating
  end

  def has_review?(%{"review" => review}) do
    review != "" && review != nil
  end

  def has_review?(_), do: false

  def has_cover?(nil), do: false

  def has_cover?(%{"cover" => cover}) when not is_nil(cover), do: true

  def has_cover?(book) do
    %{"isbn" => isbn, "isbn13" => isbn13, "goodreads" => goodreads} = book

    cover_file_exists?(isbn13) || cover_file_exists?(isbn) ||
      cover_file_exists?(goodreads)
  end

  defp cover_file_exists?(nil), do: false

  defp cover_file_exists?(id) do
    :code.priv_dir(:gabrielpoca)
    |> Path.join("site")
    |> Path.join(cover_file(id))
    |> File.exists?()
  end

  defp cover_file(nil), do: nil

  defp cover_file(id), do: Path.join(["books", "_covers", "#{id}.jpg"])
end
