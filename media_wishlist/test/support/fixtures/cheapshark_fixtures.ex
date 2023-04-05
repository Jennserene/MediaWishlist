defmodule MediaWishlist.CheapSharkFixtures do
  def search_deals_fetch_result() do
    ~S([{"gameID":"612","steamAppID":null,"cheapest":"16.05","cheapestDealID":"0f%2B4gT2VVUn4UcmFzPxXnuqoXKAOYoJ5mpFZRWNyohc%3D","external":"LEGO Batman","internalName":"LEGOBATMAN","thumb":"https:\/\/cdn.fanatical.com\/production\/product\/400x225\/105f34ca-7757-47ad-953e-7df7f016741e.jpeg"},{"gameID":"167613","steamAppID":null,"cheapest":"16.05","cheapestDealID":"2XSMlnYtPjLoKI9g2vhZch9deHZ%2BE%2BpL7IoBprkWtgM%3D","external":"LEGO Batman 2","internalName":"LEGOBATMAN2","thumb":"https:\/\/cdn.fanatical.com\/production\/product\/400x225\/4cf0701e-77bf-4539-bda7-129ab3e81f8b.jpeg"},{"gameID":"167910","steamAppID":"502820","cheapest":"15.89","cheapestDealID":"VcpkOmgsL8LmPiKN7%2BzVQm1g4xi%2B0dXAk3fMyi%2B6Xnw%3D","external":"Batman: Arkham VR","internalName":"BATMANARKHAMVR","thumb":"https:\/\/cdn.cloudflare.steamstatic.com\/steam\/apps\/502820\/capsule_sm_120.jpg?t=1617134787"}])
  end

  def deal_lookup_fetch_result() do
    ~S({"gameInfo":{"storeID":"1","gameID":"93503","name":"BioShock Infinite","steamAppID":"8870","salePrice":"11.99","retailPrice":"59.99","steamRatingText":"Very Positive","steamRatingPercent":"93","steamRatingCount":"97517","metacriticScore":"94","metacriticLink":"\/game\/pc\/bioshock-infinite","releaseDate":1364169600,"publisher":"N\/A","steamworks":"1","thumb":"https:\/\/cdn.cloudflare.steamstatic.com\/steam\/apps\/8870\/capsule_sm_120.jpg?t=1602794480"},"cheaperStores":[{"dealID":"boC2N0Q7SMCKxv6UKjRw%2BLFY6%2BNLEeWM2Bf1i80clx0%3D","storeID":"21","salePrice":"5.99","retailPrice":"29.99"},{"dealID":"kj2H%2FvwfkyU40jW9s2g88CAW4PuR0etKlYvkQLitgvQ%3D","storeID":"29","salePrice":"6.75","retailPrice":"29.99"}],"cheapestPrice":{"price":"4.49","date":1657640894}})
  end

  def game_deals_lookup_fetch_result() do
    ~S({"info":{"title":"LEGO Batman","steamAppID":null,"thumb":"https:\/\/cdn.fanatical.com\/production\/product\/400x225\/105f34ca-7757-47ad-953e-7df7f016741e.jpeg"},"cheapestPriceEver":{"price":"3.99","date":1543028665},"deals":[{"storeID":"15","dealID":"0f%2B4gT2VVUn4UcmFzPxXnuqoXKAOYoJ5mpFZRWNyohc%3D","price":"16.05","retailPrice":"19.99","savings":"19.709855"},{"storeID":"23","dealID":"tyTH88J0PXRvYALBjV3cNHd5Juq1qKcu4tG4lBiUCt4%3D","price":"16.79","retailPrice":"19.99","savings":"16.008004"},{"storeID":"28","dealID":"atibivJQyXsOousolMoHm2iwPKyZaYMxbJ0sR0030M4%3D","price":"16.99","retailPrice":"19.99","savings":"15.007504"},{"storeID":"33","dealID":"KmNq80463%2FLJa0y3ZbxxVR3RhccNKfseI1XWmI35Qlo%3D","price":"18.99","retailPrice":"19.99","savings":"5.002501"},{"storeID":"21","dealID":"Dtzv5PHBf71720cIYjxx3oHvvZK3iHUbQjv6fWLVpd8%3D","price":"19.99","retailPrice":"19.99","savings":"0.000000"},{"storeID":"29","dealID":"xNmgQhGtVg4jTX9yZLbB5WsnkDKve8NUO8PfEHEbLZc%3D","price":"19.99","retailPrice":"19.99","savings":"0.000000"}]})
  end

  def search_deals_decode_result() do
    [
      %Deal{
        gameID: "612",
        steamAppID: nil,
        cheapest: "16.05",
        cheapestDealID: "0f%2B4gT2VVUn4UcmFzPxXnuqoXKAOYoJ5mpFZRWNyohc%3D",
        external: "LEGO Batman",
        thumb:
          "https://cdn.fanatical.com/production/product/400x225/105f34ca-7757-47ad-953e-7df7f016741e.jpeg"
      },
      %Deal{
        gameID: "167613",
        steamAppID: nil,
        cheapest: "16.05",
        cheapestDealID: "2XSMlnYtPjLoKI9g2vhZch9deHZ%2BE%2BpL7IoBprkWtgM%3D",
        external: "LEGO Batman 2",
        thumb:
          "https://cdn.fanatical.com/production/product/400x225/4cf0701e-77bf-4539-bda7-129ab3e81f8b.jpeg"
      },
      %Deal{
        gameID: "167910",
        steamAppID: "502820",
        cheapest: "15.89",
        cheapestDealID: "VcpkOmgsL8LmPiKN7%2BzVQm1g4xi%2B0dXAk3fMyi%2B6Xnw%3D",
        external: "Batman: Arkham VR",
        thumb:
          "https://cdn.cloudflare.steamstatic.com/steam/apps/502820/capsule_sm_120.jpg?t=1617134787"
      }
    ]
  end

  def deal_lookup_decode_result() do
    %SingleDeal{
      cheaperStores: [
        %{
          "dealID" => "boC2N0Q7SMCKxv6UKjRw%2BLFY6%2BNLEeWM2Bf1i80clx0%3D",
          "retailPrice" => "29.99",
          "salePrice" => "5.99",
          "storeID" => "21"
        },
        %{
          "dealID" => "kj2H%2FvwfkyU40jW9s2g88CAW4PuR0etKlYvkQLitgvQ%3D",
          "retailPrice" => "29.99",
          "salePrice" => "6.75",
          "storeID" => "29"
        }
      ],
      cheapestPrice: %{"date" => 1_657_640_894, "price" => "4.49"},
      gameInfo: %GameInfo{
        storeID: "1",
        gameID: "93503",
        name: "BioShock Infinite",
        steamAppID: "8870",
        salePrice: "11.99",
        retailPrice: "59.99",
        steamRatingText: "Very Positive",
        steamRatingPercent: "93",
        steamRatingCount: "97517",
        metacriticScore: "94",
        metacriticLink: "/game/pc/bioshock-infinite",
        releaseDate: 1_364_169_600,
        publisher: "N/A",
        steamworks: "1",
        thumb:
          "https://cdn.cloudflare.steamstatic.com/steam/apps/8870/capsule_sm_120.jpg?t=1602794480"
      }
    }
  end

  def convert_to_favorite_result() do
    %{
      currPrice: "11.99",
      dealID: "test_id",
      gameID: "93503",
      metacriticLink: "/game/pc/bioshock-infinite",
      onSale: true,
      retailPrice: "59.99",
      steamAppID: "8870",
      storeID: "Steam",
      thumb:
        "https://cdn.cloudflare.steamstatic.com/steam/apps/8870/capsule_sm_120.jpg?t=1602794480",
      title: "BioShock Infinite"
    }
  end

  def game_deals_lookup_decode_result() do
    %SingleGameDeals{
      cheapestPriceEver: %{"date" => 1_543_028_665, "price" => "3.99"},
      deals: [
        %SingleGameDeal{
          storeID: "15",
          dealID: "0f%2B4gT2VVUn4UcmFzPxXnuqoXKAOYoJ5mpFZRWNyohc%3D",
          price: "16.05",
          retailPrice: "19.99",
          savings: "19.709855"
        },
        %SingleGameDeal{
          storeID: "23",
          dealID: "tyTH88J0PXRvYALBjV3cNHd5Juq1qKcu4tG4lBiUCt4%3D",
          price: "16.79",
          retailPrice: "19.99",
          savings: "16.008004"
        },
        %SingleGameDeal{
          storeID: "28",
          dealID: "atibivJQyXsOousolMoHm2iwPKyZaYMxbJ0sR0030M4%3D",
          price: "16.99",
          retailPrice: "19.99",
          savings: "15.007504"
        },
        %SingleGameDeal{
          storeID: "33",
          dealID: "KmNq80463%2FLJa0y3ZbxxVR3RhccNKfseI1XWmI35Qlo%3D",
          price: "18.99",
          retailPrice: "19.99",
          savings: "5.002501"
        },
        %SingleGameDeal{
          storeID: "21",
          dealID: "Dtzv5PHBf71720cIYjxx3oHvvZK3iHUbQjv6fWLVpd8%3D",
          price: "19.99",
          retailPrice: "19.99",
          savings: "0.000000"
        },
        %SingleGameDeal{
          storeID: "29",
          dealID: "xNmgQhGtVg4jTX9yZLbB5WsnkDKve8NUO8PfEHEbLZc%3D",
          price: "19.99",
          retailPrice: "19.99",
          savings: "0.000000"
        }
      ],
      info: %{
        "steamAppID" => nil,
        "thumb" =>
          "https://cdn.fanatical.com/production/product/400x225/105f34ca-7757-47ad-953e-7df7f016741e.jpeg",
        "title" => "LEGO Batman"
      }
    }
  end

  def single_store() do
    %Store{
      images: %{
        "banner" => "/img/stores/banners/0.png",
        "icon" => "/img/stores/icons/0.png",
        "logo" => "/img/stores/logos/0.png"
      },
      isActive: 1,
      storeID: "1",
      storeName: "Steam"
    }
  end

  def stores_json() do
    ~S([{"storeID":"1","storeName":"Steam","isActive":1,"images":{"banner":"\/img\/stores\/banners\/0.png","logo":"\/img\/stores\/logos\/0.png","icon":"\/img\/stores\/icons\/0.png"}}])
  end

  def foobar_stores_fetch_result() do
    ~S([{"storeID":"99999","storeName":"Foobar","isActive":1,"images":{"banner":"\/img\/stores\/banners\/0.png","logo":"\/img\/stores\/logos\/0.png","icon":"\/img\/stores\/icons\/0.png"}}])
  end

  def fetch_users_latest_prices_fetch_result() do
    ~S({"128":{"info":{"title":"BioShock","steamAppID":null,"thumb":"https:\/\/gamersgatep.imgix.net\/0\/a\/8\/be6da04fc36b9995a78d20d319b638d8fad9d8a0.jpg?auto=&w="},"cheapestPriceEver":{"price":"4.60","date":1494806794},"deals":[{"storeID":"23","dealID":"et8hm7BwoAPZnyJpSAAehTMKS7M1aPlbLKSZDWmUtEo%3D","price":"16.79","retailPrice":"19.99","savings":"16.008004"},{"storeID":"15","dealID":"oWyPURCZyImGfRbhD2zT0IhdZ4Z8WoFzQzTrQ8t23GQ%3D","price":"17.84","retailPrice":"19.99","savings":"10.755378"},{"storeID":"11","dealID":"IoCZ9drtueLEcHjcGtR%2BgdXUX9GnXHQ2tLL86zjlM90%3D","price":"19.98","retailPrice":"19.98","savings":"0.000000"},{"storeID":"2","dealID":"DlT5IxXbqt4KI7VAOZVcrt1u%2BS9qYZQ16IY4cory4Cg%3D","price":"19.99","retailPrice":"19.99","savings":"0.000000"},{"storeID":"30","dealID":"mmN9g5a3OJzlYAZS5Y7CnbKT5fVk3RyUGKQv%2BbfJTHA%3D","price":"19.99","retailPrice":"19.99","savings":"0.000000"},{"storeID":"24","dealID":"dPB13v%2FMykCkRy39LDryRmCgCc6G6rXN0h1mPvXbQyk%3D","price":"19.99","retailPrice":"19.99","savings":"0.000000"},{"storeID":"34","dealID":"QXFi%2FEUKKTtf86zeNbkc0%2F6MTZ8ZQd5MYJdTw%2BXkdwk%3D","price":"19.99","retailPrice":"19.99","savings":"0.000000"},{"storeID":"33","dealID":"dMKdFSJ01mPBfcmjCGS0q1pFjSNf44uPI6WP9XrvNME%3D","price":"19.99","retailPrice":"19.99","savings":"0.000000"},{"storeID":"29","dealID":"cLKxizhmpyEkhGp0fZnFSXhRgU382U5iTkluKEwAizw%3D","price":"19.99","retailPrice":"19.99","savings":"0.000000"},{"storeID":"35","dealID":"ZYfDUcVNcGrJrdPtndBWjWul8RlfuCZi6lriNsze6gk%3D","price":"19.99","retailPrice":"19.99","savings":"0.000000"}]}})
  end
end
