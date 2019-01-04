# frozen_string_literal: true

class Offer
  def initialize(product_code:, threshold:, discount_in_units:); end

  def evaluate_products(products)
    # Check if the catalogue meets the offer threshold
    # If yes, return the total for the products on offer and a modified list without these products.
  end
end
