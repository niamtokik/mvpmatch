# Challenge

from: https://mvpmatch.notion.site/Full-stack-ac8a8b07bee84937968377c840b6fa29

## Stories

Design an API for a vending machine, allowing users with a “seller”
role to add, update or remove products, while users with a “buyer”
role can deposit coins into the machine and make purchases. Your
vending machine should only accept 5, 10, 20, 50 and 100 cent coins

## Tasks

- REST API should be implemented consuming and producing
  “application/json”

- Implement product model with amountAvailable, cost, productName and
  sellerId fields

- Implement user model with username, password, deposit and role
  fields

- Implement an authentication method (basic, oAuth, JWT or something
  else, the choice is yours)

- All of the endpoints should be authenticated unless stated otherwise

- Implement CRUD for users (POST /user should not require
  authentication to allow new user registration)

- Implement CRUD for a product model (GET can be called by anyone,
  while POST, PUT and DELETE can be called only by the seller user who
  created the product)

- Implement /deposit endpoint so users with a “buyer” role can deposit
  only 5, 10, 20, 50 and 100 cent coins into their vending machine
  account

- Implement /buy endpoint (accepts productId, amount of products) so
  users with a “buyer” role can buy products with the money they’ve
  deposited. API should return total they’ve spent, products they’ve
  purchased and their change if there’s any (in an array of 5, 10, 20,
  50 and 100 cent coins)

- Implement /reset endpoint so users with a “buyer” role can reset
  their deposit back to 0

- Create web interface for interaction with the API, design choices
  are left to you

- Take time to think about possible edge cases and access issues that
  should be solved
