defmodule Mix.Tasks.ImportGoodreads do
  use Mix.Task

  @ouput_file "site/_data/goodreads.json"

  @impl Mix.Task
  def run([file | _]) do
    contents =
      file
      |> Path.expand()
      |> File.stream!()
      |> CSV.decode(headers: true)
      |> Stream.map(fn {:ok, book} -> book end)
      |> Stream.filter(fn book -> book["Exclusive Shelf"] == "read" end)
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
      |> Stream.map(fn book ->
        book
        |> Map.put("Formatted Date Read", book_date_read(book["Date Read"]))
        |> Map.put("ISBN", String.replace_prefix(book["ISBN"], "=", ""))
      end)
      |> Enum.to_list()
      |> Enum.sort_by(&(&1["Date Read"] || Date.from_erl!({2008, 01, 01})), {:desc, Date})
      |> Jason.encode!()

    File.write!(get_output_file(), contents)
  end

  defp book_date_read(nil) do
    nil
  end

  defp book_date_read(date) do
    date |> Timex.format!("%Y-%m-%d", :strftime)
  end

  defp get_output_file do
    :code.priv_dir(:gabrielpoca)
    |> Path.join([@ouput_file])
  end
end
