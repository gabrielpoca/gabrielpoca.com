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
          Date.utc_today()
      end)
    end)
    |> Enum.to_list()
    |> Enum.sort_by(& &1["Date Read"], {:desc, Date})
  end
end
