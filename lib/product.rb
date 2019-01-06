# frozen_string_literal: true

require_relative 'validations'

# A simple representation of a product than can be purchased.
class Product
  attr_reader :name, :code, :price
  def initialize(name:, code:, price:)
    @name = name
    @code = code
    @price = price
    Validations.ensure_positive_number(price, 'price')
  end
end
