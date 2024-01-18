# TODOs

## Authentication

- [x] encrypted password with argon2

- [x] basic auth support

- [x] jwt support

## Accounts

- [x] create user using POST on `/user` without authentication

- [x] show user information using GET on `/user` with authentication

- [x] an username must be unique

- [ ] an authenticated user can delete his account

- [x] an username must be only characters and numbers

## Buyers

- [x] an user becomes a buyer when adding coins with POST `/deposit`

- [x] a buyer can add 5 coins with POST `/deposit`

- [x] a buyer can add 10 coins with POST `/deposit`

- [x] a buyer can add 20 coins with POST `/deposit`

- [x] a buyer can add 50 coins with POST `/deposit`

- [x] a buyer can add 100 coins with POST `/deposit`

- [x] a buyer can buy one amount of one product with POST `/buy`

- [x] a buyer can reset his deposit with POST `/reset`

- [x] a buyer can't buy his own product if he is a seller

- [ ] a buyer can remove his role with DELETE `/user/buyer`

- [ ] a buyer can buy more than one product

## Sellers

- [x] an user becomes a seller when creating a new product with POST
  `/products`

- [x] a seller can create a new product with POST `/products`

- [x] a seller can update a product with POST `/products/:product_id`

- [x] a seller can delete a product with DELETE `/products/:product_id`

- [ ] a seller can remove his role with DELETE `/user/seller`

- [ ] a seller can remove more than one product

## Products

- [x] all products can be displayed with GET `/products`

- [ ] one product can be displayed with GET `/products/:product_id`

- [ ] a product must have an UUID

## Testing

- [ ] Test basic auth authentication method

- [ ] Test jwt authentication method

- [ ] Test accounts end-points

- [ ] Test buyers end-points

- [ ] Test sellers end-points

- [ ] Test products end-points

## Developer Toolbox

- [x] add `asdf` `.tool-versions` 

- [x] create phoenix/elixir shortcut

- [x] create `README.md`

- [x] testing with curl

- [x] added insomnia rules/playbook

## Platform

- [x] create production release

- [x] create `Dockerfile`

- [x] create `docker-compose.yaml`
