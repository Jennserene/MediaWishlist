defmodule MediaWishlist.FetchDaily do
  use GenServer
  alias MediaWishlist.Accounts
  require Logger

  def start_link(_opts) do
    GenServer.start_link(__MODULE__, %{})
  end

  def init(state) do
    Logger.info(
      "Prepared to fetch pricing data daily for #{Accounts.num_subscribers()} " <>
        "subscribers starting in 24 hours. This will change with use."
    )

    schedule_work()
    {:ok, state}
  end

  def handle_info(:work, state) do
    schedule_work()
    fetch_for_subscribed_users()
    {:noreply, state}
  end

  defp schedule_work() do
    Process.send_after(self(), :work, 24 * 60 * 60 * 1000)
  end

  def fetch_for_subscribed_users() do
    Logger.info("Fetching pricing data for #{Accounts.num_subscribers()} subscribers.")

    Accounts.list_subscribed_users()
    |> Enum.each(fn user -> CheapSharkApi.fetch_all_for_user(user.id, user.email, true) end)

    Logger.info("Fetching completed. Next fetch for subscribers in 24 hours.")
  end
end
