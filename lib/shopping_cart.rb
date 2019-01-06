# frozen_string_literal: true

require_relative 'validations'
require_relative 'basket'
require_relative 'catalogue'
require_relative 'delivery_cost_schedule'
require_relative 'offer'

# The core shopping cart entity that has a catalogue, set of delivery charges, available offers.
# Products can be added and put in a basket. The shopping cart calulates the total cost of an order
# taking both available offers and delivery into account.
class ShoppingCart
  CURRENCY = '£'
  attr_reader :catalogue, :delivery_cost_schedule, :offers, :basket
  def initialize(catalogue:, delivery_cost_schedule:, offers: [])
    @catalogue = catalogue
    @delivery_cost_schedule = delivery_cost_schedule
    @offers = offers
    @basket = Basket.new
    validate_parameters
  end

  def add(product_code)
    message = 'Only products in the catalogue can be added to the shopping cart.'
    Validations.ensure_argument(catalogue.includes_code?(product_code), message)

    basket.add catalogue.product_by_code product_code
  end

  def empty!
    basket.empty!
  end

  alias << add

  def total
    basket_total = basket.total(offers: offers)
    shipping = delivery_cost_schedule.delivery_cost(amount_spent: basket_total)
    # Round down to the nearest penny.
    total_cost = format('%.2f', ((basket_total + shipping) * 100).floor / 100.0)
    "#{CURRENCY}#{total_cost}"
  end

  private

  def validate_parameters
    Validations.ensure_is_a(catalogue, 'catalogue', Catalogue)
    Validations.ensure_is_a(delivery_cost_schedule, 'delivery_cost_schedule', DeliveryCostSchedule)
    Validations.ensure_is_an_array_of(offers, 'offers', Offer)
  end
end
