# Media Wishlist

## Requirements

Erlang/OTP 25  
Elixir 1.14.4  
PostgreSQL 14.7

## Local Installation

Ensure that your Postgres database has a `postgres` superuser with `postgres` password.  
Ensure that there is a database named `media_wishlist_dev`

To do a fresh installation run:

```bash
mix setup
```

## Usage

To start the Media Wishlist server run:

```bash
mix phx.server
```

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

To run tests run:

```bash
mix test
```
