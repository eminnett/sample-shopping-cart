# frozen_string_literal: true

class ShopppingCart
  def initialize(catalogue, delivery_cost_schedule, offers)
    @catalogue = catalogue
    @delivery_cost_schedule = delivery_cost_schedule
    @offers = offers
    @basket = Basket.new
  end

  def add(product_code)
    # Lookup product in catalogue
    # Raise error if the product doesn't exist
    # Add the product to the basket
  end

  def total
    # Get total from basket
    # Add shipping costs
  end
end
