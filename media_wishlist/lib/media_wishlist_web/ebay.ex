defmodule EbayApi do
  use OAuth2.Strategy

  def new do
    OAuth2.Client.new([
      strategy: __MODULE__,
      client_id: "EBAY_ID",
      client_secret: "EBAY_SECRET",
      redirect_uri: "http://localhost:4000/search",
      site: "https://auth.ebay.com/oauth2/authorize?"
    ])
    |> OAuth2.Client.put_serializer("application/json", Jason)
  end

  def get_token(client, params, headers) do
    client
    |> put_header("Accept", "application/json")
    |> OAuth2.Strategy.AuthCode.get_token(params, headers)
  end
end
