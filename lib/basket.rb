# frozen_string_literal: true

class Basket
  def initialize
    @products = []
  end

  def add(product)
    @product << product
  end

  def total(offers)
    # loop through offers
    # for each offer keep applying the offer to the basket until the product list doesn't change
  end
end
