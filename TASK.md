# Sample Shopping Cart

The client decided to open a hyper-focused online shop that sells only three things -
jeans, blouses, and socks. Each product has a corresponding product code and price:

| **Product** | **Code** | **Price** |
|:-----------:|:--------:| ---------:|
| Jeans       | J01      |    £32.95 |
| Blouse      | B01      |    £24.95 |
| Socks       | S01      |     £7.95 |

To try and incentivise customers to spend more with us, the delivery charges are staggered. For
orders under £50 delivery costs £4.95. For orders under £90, delivery costs £2.95. Orders over
£90 have free delivery.

We're also experimenting with special offers. The initial offer will be “buy one pair, get another
pair half price” on jeans. The final piece of code to write is the basket, which needs to have the
following interface:

- It is initialised with the product catalog, delivery charge rules, and offers (the format of how
these are passed is up to you)
- It has an add method that takes the product code as a parameter
- It has a total method that returns the total cost of the basket, taking into account the delivery and offer rules

So that you can check your implementation, here are some example baskets and the expected totals:

| **Products**            | **Basket Total** |
|:-----------------------:| ----------------:|
| S01, J01                |           £32.95 |
| J01, J01                |           £24.95 |
| J01, B01                |            £7.95 |
| S01, S01, J01, J01, J01 |            £7.95 |
