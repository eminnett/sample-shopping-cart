# Cron Task

Edward Minnett - January 6th, 2019

## Overview

The Ruby files in the `lib` directory address the problem described in `TASK.md`. The library
represents a simple shopping cart that supports a catalogue of products, discount offers for
those products, and tiered shipping costs.

## Setup

Run `bundle install` from the project directory to install the project dependencies.

## Execution

The best way to show how to use the library is to illustrate the use case described in `TASK.md`
written using the library code (this block is executable in IRB).

```Ruby
require_relative 'lib/shopping_cart'

# Create the three Products
jeans  = Product.new(name: 'Jeans', code: 'J01', price: 32.95)
blouse = Product.new(name: 'Blouse', code: 'B01', price: 24.95)
socks  = Product.new(name: 'Socks', code: 'S01', price: 7.95)

# Add the products to the Catalogue
c = Catalogue.new
c.add(jeans)
c.add(blouse)
c.add(socks)

# Setup the delivery charges
d = DeliveryCostSchedule.new(base_delivery_cost: 4.95)
d.add_tier(threshold: 50, delivery_cost: 2.95)
d.add_tier(threshold: 90, delivery_cost: 0)

# Define the offer, 'buy one pair, get another pair half price' on jeans
o = Offer.new(product_code: jeans.code, threshold: 2, discount_in_units: 0.5)

# Initialise the ShoppingCart
shopping_cart = ShoppingCart.new(catalogue: c, delivery_cost_schedule: d, offers: [o])

# The fourth example basket from the task description
2.times { shopping_cart.add(socks.code) }
3.times { shopping_cart.add(jeans.code) }
shopping_cart.total == '£98.27' # This would be true
```

This along with the other three test cases make up the majority of the test cases
in `spec/shopping_cart_spec.rb`.

## Testing

The project was developed and tested on OSX 10.14 using Ruby 2.5.3.

Run `bundle exec rspec` from the project directory to execute the automated tests.

Run `bundle exec rubocop` from the project directory to check that all the ruby files conform
to standard code styling.
