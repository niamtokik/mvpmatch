# MVPMatch Challenge

A simple, quick and dirty, implementation of [MVP
Challenge](CHALLENGE.md) in Elixir.

## Usage

For developers. you will need to install postgresql. The environment
can be bootstrapped locally with [asdf](https://asdf-vm.com/).

```sh
asdf install
mix do deps.get, compile, ecto.setup
iex -S mix phx.server
```

For testing.

```sh
MIX_ENV=test mix do ecto.reset, test
```

For local usage with Docker and docker-compose.

```sh
docker-compose build
docker-compose up
```

[Insomnia](https://insomnia.rest/) - a free and open-source
alternative to postman - rules are available in
[insomnia_mvpmatch.json](insomnia_mvpmatch.json) file. You can install
it directly from the official website or from flatpak:

```sh
flatpak install --user rest.insomnia.Insomnia
flatpak run --user rest.insomnia.Insomnia
```



## Manual Tests with cURL

```sh
export TARGET=localhost:4000

# create a new user "foo"
curl -XPOST -H"content-type: application/json" http://${TARGET}/user -d '{"username": "foo", "password": "bar"}'
curl http://foo:bar@${TARGET}/user

# create a new user "bar"
curl -XPOST -H"content-type: application/json" http://${TARGET}/user -d '{"username": "bar", "password": "foo"}'
curl http://bar:foo@${TARGET}/user

# set foo as buyer by adding coins
curl -XPOST -H"content-type: application/json" http://foo:bar@${TARGET}/deposit -d '{"coins": 10}'
curl -XPOST -H"content-type: application/json" http://foo:bar@${TARGET}/deposit -d '{"coins": 100}'
curl -XPOST -H"content-type: application/json" http://foo:bar@${TARGET}/deposit -d '{"coins": 20}'

# set bar as seller by creating a new product
curl -XPOST -H"content-type: application/json" http://bar:foo@${TARGET}/products -d '{"name": "cider", "cost": 10, "amount": 20}'
curl -XPOST -H"content-type: application/json" http://bar:foo@${TARGET}/products -d '{"name": "wine", "cost": 1000, "amount": 50}'
curl -XPOST -H"content-type: application/json" http://bar:foo@${TARGET}/products -d '{"name": "beer", "cost": 5, "amount": 100}'
curl -XPOST -H"content-type: application/json" http://bar:foo@${TARGET}/products -d '{"name": "miss", "cost": 5, "amount": 1}'

# delete a product
curl -XDELETE http://bar:foo@${TARGET}/products/4

# buy a bottle of cider
curl -XPOST -H"content-type: application/json" http://foo:bar@${TARGET}/buy -d '{"product_id": 1}'
curl -XPOST -H"content-type: application/json" http://foo:bar@${TARGET}/buy -d '{"product_id": 1, "amount": 5}'
```

## TODO

A todo list is available in [TODO.md](TODO.md) file.

## Notes

1. Currently, only basic auth is supported.

2. An `user` can be both a `seller` or a `buyer`. When doing a first
   deposit, an `user` becomes **automatically** a `buyer`. When
   creating a new product, an `user` becomes **automatically** a
   `seller`. An user can't buy his own products.
   

