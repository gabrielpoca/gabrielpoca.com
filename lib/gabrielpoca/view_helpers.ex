defmodule GabrielPoca.ViewHelpers do
  def sort_posts(posts) do
    posts |> Enum.sort_by(& &1[:variables][:date]) |> Enum.reverse()
  end

  def pub_date(date) do
    date
    |> Timex.parse!("{YYYY}-{0M}-{D}")
    |> Timex.format!("%a, %e %b %Y 00:00:00 GMT", :strftime)
  end
end
