# frozen_string_literal: true

require_relative 'validations'
require_relative 'product'

# Represents a conditional discount for a specific product based on how many of the relevant product
# is being purchased. The discount is defined in terms of a number of units where this can be a
# fraction. Here are a few examples:
#
# 'Buy two, get one free.' would be represented by
#   Offer.new(product_code: 'product code', threshold: 3, discount_in_units: 1)
#
# 'Buy three, get a fourth for half the price.' would be represented by
#   Offer.new(product_code: 'product code', threshold: 4, discount_in_units: 0.5)
class Offer
  attr_reader :product_code, :threshold, :discount_in_units
  def initialize(product_code:, threshold:, discount_in_units:)
    @product_code = product_code
    @threshold = threshold
    @discount_in_units = discount_in_units
    validate_parameters
  end

  def evaluate_products(products:)
    validate_products products
    relevant_products = products.select { |p| p.code == product_code }
    return [products, 0] if relevant_products.count < threshold

    apply_offer products, relevant_products
  end

  private

  def validate_parameters
    Validations.ensure_positive_integer(threshold, 'threshold')
    Validations.ensure_positive_number(discount_in_units, 'discount_in_units')
    message = "An Offer's discount_in_units must be less than the threshold."
    Validations.ensure_argument(threshold > discount_in_units, message)
  end

  def validate_products(products)
    message = 'Only an array of Products can be evaluated by an Offer.'
    Validations.ensure_is_an_array_of(products, 'products', Product, message: message)
  end

  def apply_offer(all_products, relevant_products)
    # We can't use array subtraction as this will remove all matching duplicates,
    # not just those matching the offer.
    relevant_products.first(threshold).each do |p|
      index = all_products.index(p)
      all_products.delete_at(index) if index
    end
    cost_of_offer = relevant_products.first.price * (threshold - discount_in_units)
    [all_products, cost_of_offer]
  end
end
