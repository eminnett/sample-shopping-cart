# frozen_string_literal: true

require 'spec_helper'
require_relative '../lib/delivery_cost_schedule'

RSpec.describe DeliveryCostSchedule do
  let(:base_delivery_cost) { 9.99 }
  let(:discounted_delivery_cost) { 4.99 }
  let(:delivery_cost_schedule) { DeliveryCostSchedule.new(base_delivery_cost: base_delivery_cost) }
  let(:base_delivery_cost_error_message) do
    "A DeliveryCostSchedule's base_delivery_cost must be a non-negative number."
  end

  describe 'parameter validation' do
    context 'when the parameters are valid' do
      it 'does not raise an error' do
        expect { DeliveryCostSchedule.new(base_delivery_cost: 4.99) }
          .to_not raise_error
      end
    end

    context 'when the base_delivery_cost is 0' do
      it 'does not raise an error' do
        expect { DeliveryCostSchedule.new(base_delivery_cost: 0) }
          .to_not raise_error
      end
    end

    context 'when the base_delivery_cost is not a number' do
      it 'raises an error' do
        expect { DeliveryCostSchedule.new(base_delivery_cost: '4.99') }
          .to raise_error(ArgumentError, base_delivery_cost_error_message)
      end
    end

    context 'when the base_delivery_cost is negative' do
      it 'raises an error' do
        expect { DeliveryCostSchedule.new(base_delivery_cost: -4.99) }
          .to raise_error(ArgumentError, base_delivery_cost_error_message)
      end
    end
  end

  describe '#tiers' do
    it 'includes the base delivery cost' do
      expect(delivery_cost_schedule.tiers)
        .to include(threshold: 0, delivery_cost: base_delivery_cost)
    end
  end

  describe '#add_tier' do
    describe 'parameter validation' do
      let(:threshold_error_message) do
        "A DeliveryCostSchedule's tier threshold must be a positive number."
      end
      let(:delivery_cost_error_message) do
        "A DeliveryCostSchedule's tier delivery_cost must be a non-negative number."
      end

      context 'when the threshold is not a number' do
        it 'raises an error' do
          expect { delivery_cost_schedule.add_tier(threshold: '50', delivery_cost: 4.99) }
            .to raise_error(ArgumentError, threshold_error_message)
        end
      end

      context 'when the threshold is negative' do
        it 'raises an error' do
          expect { delivery_cost_schedule.add_tier(threshold: -50, delivery_cost: 4.99) }
            .to raise_error(ArgumentError, threshold_error_message)
        end
      end

      context 'when the threshold is 0' do
        it 'raises an error' do
          expect { delivery_cost_schedule.add_tier(threshold: 0, delivery_cost: 4.99) }
            .to raise_error(ArgumentError, threshold_error_message)
        end
      end

      context 'when the delivery_cost is not a number' do
        it 'raises an error' do
          expect { delivery_cost_schedule.add_tier(threshold: 50, delivery_cost: '4.99') }
            .to raise_error(ArgumentError, delivery_cost_error_message)
        end
      end

      context 'when the delivery_cost is negative' do
        it 'raises an error' do
          expect { delivery_cost_schedule.add_tier(threshold: 50, delivery_cost: -4.99) }
            .to raise_error(ArgumentError, delivery_cost_error_message)
        end
      end

      context 'when the delivery_cost is 0' do
        it 'does not raise an error' do
          expect { delivery_cost_schedule.add_tier(threshold: 50, delivery_cost: 0) }
            .to_not raise_error
        end
      end
    end

    context 'when a tier is added' do
      it 'is in the list of cost tiers' do
        delivery_cost_schedule.add_tier(threshold: 50, delivery_cost: 0)
        expect(delivery_cost_schedule.tiers).to include(threshold: 50, delivery_cost: 0)
      end
    end

    context 'when tiers are added out of order' do
      it 'sorts the tiers by thershold' do
        delivery_cost_schedule.add_tier(threshold: 100, delivery_cost: 0)
        delivery_cost_schedule.add_tier(threshold: 50, delivery_cost: 4.99)
        expect(delivery_cost_schedule.tiers.map { |t| t[:threshold] }).to eq([0, 50, 100])
      end
    end
  end

  describe '#delivery_cost' do
    describe 'parameter validation' do
      let(:amount_spent_error_message) do
        'The amount spent when calculating the delivery cost must be a positive number.'
      end

      context 'when the threshold is not a number' do
        it 'raises an error' do
          expect { delivery_cost_schedule.delivery_cost(amount_spent: '10') }
            .to raise_error(ArgumentError, amount_spent_error_message)
        end
      end

      context 'when the threshold is negative' do
        it 'raises an error' do
          expect { delivery_cost_schedule.delivery_cost(amount_spent: -10) }
            .to raise_error(ArgumentError, amount_spent_error_message)
        end
      end

      context 'when the threshold is 0' do
        it 'raises an error' do
          expect { delivery_cost_schedule.delivery_cost(amount_spent: 0) }
            .to raise_error(ArgumentError, amount_spent_error_message)
        end
      end
    end

    context 'when the amount spent does not meet the threshold for discounted delivery' do
      it 'returns the base delivery cost' do
        delivery_cost_schedule.add_tier(threshold: 50, delivery_cost: discounted_delivery_cost)
        expect(delivery_cost_schedule.delivery_cost(amount_spent: 49.99)).to eq(base_delivery_cost)
      end
    end

    context 'when the amount spent does meet the threshold for discounted delivery' do
      it 'returns the discounted delivery cost' do
        discounted_delivery_cost
        delivery_cost_schedule.add_tier(threshold: 50, delivery_cost: discounted_delivery_cost)
        expect(delivery_cost_schedule.delivery_cost(amount_spent: 50))
          .to eq(discounted_delivery_cost)
      end
    end
  end
end
