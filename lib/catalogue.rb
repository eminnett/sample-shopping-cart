# frozen_string_literal: true

require_relative 'product'

# Represents the list of products that can be purchased. The products in a catalogue
# must have unique product codes.
class Catalogue
  attr_reader :products
  def initialize
    @products = []
  end

  def add(product)
    message = 'A Catalogue can only include Products.'
    Validations.ensure_is_a(product, 'product', Product, message: message)
    message = 'Products in a catalogue must have unique codes.'
    Validations.ensure_argument(!includes_code?(product.code), message)

    @products << product
  end

  alias << add

  def includes_code?(code)
    !product_by_code(code).nil?
  end

  def product_by_code(code)
    products.select { |p| p.code == code }.first
  end
end
