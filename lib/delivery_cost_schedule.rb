# frozen_string_literal: true

# The cost shecudule for shipping orders. The base delivery cost is used if the amount spent on an
# order is less than the threshold for the lowest tier. If the amount spent exceeds the  threshold
# for at least one tier, the discounted delivery cost matching the amounmt spent is applied.
class DeliveryCostSchedule
  attr_reader :tiers
  def initialize(base_delivery_cost:)
    @base_delivery_cost = base_delivery_cost
    @tiers = [{ threshold: 0, delivery_cost: base_delivery_cost }]
    Validations.ensure_non_negative_number(base_delivery_cost, 'base_delivery_cost')
  end

  def add_tier(threshold:, delivery_cost:)
    Validations.ensure_positive_number(threshold, 'tier threshold')
    Validations.ensure_non_negative_number(delivery_cost, 'tier delivery_cost')

    @tiers << { threshold: threshold, delivery_cost: delivery_cost }
    @tiers.sort_by! { |t| t[:threshold] }
  end

  def delivery_cost(amount_spent:)
    message = 'The amount spent when calculating the delivery cost must be a positive number.'
    Validations.ensure_positive_number(amount_spent, 'amount_spent', message: message)

    cost = @base_delivery_cost
    tiers.each do |tier|
      return cost if amount_spent < tier[:threshold]

      cost = tier[:delivery_cost]
    end
    cost
  end
end
