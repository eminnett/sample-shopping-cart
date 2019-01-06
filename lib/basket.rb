# frozen_string_literal: true

require_relative 'validations'
require_relative 'product'
require_relative 'offer'

# Represents the list of products in an instance of the ShoppingCart. It encapsulates the
# logic used to calculate the cost of the list of products including the application of
# available offers.
class Basket
  attr_reader :products
  def initialize
    @products = []
  end

  def add(product)
    message = 'A Basket can only include Products.'
    Validations.ensure_is_a(product, 'product', Product, message: message)

    @products << product
  end

  def empty!
    @products = []
  end

  alias << add

  def total(offers: [])
    validate_offers offers
    return products.map(&:price).reduce(&:+) if offers.empty?

    apply_offers offers
  end

  private

  def validate_offers(offers)
    message = "Only an array of Offers can modify a Basket's total."
    Validations.ensure_is_an_array_of(offers, 'offers', Offer, message: message)
  end

  def apply_offers(offers, running_cost: 0)
    # Deep copy the products
    prods = Marshal.load(Marshal.dump(products))
    offers.each do |offer|
      loop do
        num_products = prods.count
        prods, offer_cost = offer.evaluate_products(products: prods)
        running_cost += offer_cost
        break if num_products == prods.count
      end
    end

    running_cost + (prods.map(&:price).reduce(&:+) || 0)
  end
end
