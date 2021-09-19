defmodule GabrielPoca.Books do
  def all do
    :code.priv_dir(:gabrielpoca)
    |> Path.join("goodreads_library_export.csv")
    |> File.stream!()
    |> CSV.decode(headers: true)
    |> Stream.filter(fn {:ok, book} ->
      book["Exclusive Shelf"] == "read"
    end)
    |> Stream.map(fn {:ok, book} -> book end)
    |> Stream.map(fn book ->
      Map.update!(book, "Date Read", fn
        date when date != "" ->
          [year, month, date] = String.split(date, "/")
          {year, ""} = Integer.parse(year)
          {month, ""} = Integer.parse(month)
          {date, ""} = Integer.parse(date)

          Date.from_erl!({year, month, date})

        _date ->
          Date.from_erl!({2008, 01, 01})
      end)
    end)
    |> Enum.to_list()
    |> Enum.sort_by(& &1["Date Read"], {:desc, Date})
  end

  def transform do
    :code.priv_dir(:gabrielpoca)
    |> Path.join("goodreads_library_export.csv")
    |> File.stream!()
    |> CSV.decode(headers: true)
    |> Stream.filter(fn {:ok, book} ->
      book["Exclusive Shelf"] == "read"
    end)
    |> Stream.map(fn {:ok, book} -> book end)
    |> Stream.map(fn book ->
      Map.update!(book, "Date Read", fn
        date when date != "" ->
          [year, month, date] = String.split(date, "/")
          {year, ""} = Integer.parse(year)
          {month, ""} = Integer.parse(month)
          {date, ""} = Integer.parse(date)

          Date.from_erl!({year, month, date})

        _date ->
          nil
      end)
    end)
    |> Enum.to_list()
    |> Enum.map(fn book ->
      content = """
      ---
      author: "#{book["Author"]}"
      dark: true
      date: #{book_date_read(book["Date Read"])}
      isbn: #{book["ISBN"] |> String.replace_prefix("=", "")}
      layout: _includes/book_layout.slime
      rating: #{book["My Rating"]}
      tag:
        - book
      title: "#{book["Title"]}"
      has_review: #{book["My Review"] != ""}
      ---

      #{book["My Review"]}
      """

      folder = File.cwd!() |> Path.join("priv/site/books")
      file = Path.join(folder, book_id(book))

      File.write!(file, content)
    end)
  end

  defp book_date_read(nil) do
    ""
  end

  defp book_date_read(date) do
    date |> Timex.format!("%Y-%m-%d", :strftime)
  end

  defp book_id(%{"Date Read" => date, "Title" => title}) when not is_nil(date) do
    fdate = date |> Timex.format!("%y%m%d", :strftime)

    "#{fdate}_#{Slug.slugify(title, separator: "_")}.md"
  end

  defp book_id(%{"Title" => title}) do
    "#{Slug.slugify(title, separator: "_")}.md"
  end
end
