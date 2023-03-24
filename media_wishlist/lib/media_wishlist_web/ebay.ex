defmodule EbayApi do
  use OAuth2.Strategy

  def new do
    OAuth2.Client.new([
      strategy: __MODULE__,
      client_id: "SereneHe-mediawis-PRD-5cd6d2723-83b4195d",
      client_secret: "PRD-cd6d2723b636-28ce-4251-a630-1aa3",
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
