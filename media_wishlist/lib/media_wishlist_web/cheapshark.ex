defmodule CheapSharkApi do

  @list_of_deals [%Deal{}]

  def search_deals(search_term) do
    url = "https://www.cheapshark.com/api/1.0/games?title=#{search_term}"

    fetch_data(url)
    |> Poison.decode!(%{as: @list_of_deals})
  end

  def fetch_data(url) do
    case HTTPoison.get(url) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        body
      {:ok, %HTTPoison.Response{status_code: 404}} ->
        "404 error"
      {:error, %HTTPoison.Error{reason: reason}} ->
        IO.inspect reason
    end
  end
end
