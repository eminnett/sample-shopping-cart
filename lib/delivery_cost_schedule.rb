# frozen_string_literal: true

class DeliveryCostSchedule
  def initialize(base_delivery_cost)
    @base_delivery_cost = base_delivery_cost
    @tiers = []
  end

  def add_tier(threshold:, delivery_cost:)
    # Add tier to tiers
    # Sort tiers from smallest thershold to highest
  end

  def delivery_cost(amount_being_spent)
    # Return tier value for the appropriate tier or the base cost if no tier is met.
  end
end
