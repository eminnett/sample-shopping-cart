# frozen_string_literal: true

require 'spec_helper'
require_relative '../lib/shopping_cart'

RSpec.describe ShoppingCart do
  let(:jeans) { Product.new(name: 'Jeans', code: 'J01', price: 32.95) }
  let(:blouse) { Product.new(name: 'Blouse', code: 'B01', price: 24.95) }
  let(:socks) { Product.new(name: 'Socks', code: 'S01', price: 7.95) }
  let(:catalogue) do
    c = Catalogue.new
    c.add(jeans)
    c.add(blouse)
    c.add(socks)
    c
  end
  let(:delivery_cost_schedule) do
    d = DeliveryCostSchedule.new(base_delivery_cost: 4.95)
    d.add_tier(threshold: 50, delivery_cost: 2.95)
    d.add_tier(threshold: 90, delivery_cost: 0)
    d
  end
  let(:offers) do
    # 'buy one pair, get another pair half price' on jeans
    [Offer.new(product_code: jeans.code, threshold: 2, discount_in_units: 0.5)]
  end
  let(:shopping_cart) do
    ShoppingCart.new(
      catalogue: catalogue,
      delivery_cost_schedule: delivery_cost_schedule,
      offers: offers
    )
  end

  describe 'parameter validation' do
    context 'when the parameters are valid' do
      it 'raises an error' do
        expect do
          ShoppingCart.new(
            catalogue: catalogue,
            delivery_cost_schedule: delivery_cost_schedule,
            offers: offers
          )
        end.to_not raise_error
      end
    end

    context 'when the catalogue is not a Catalogue' do
      it 'raises an error' do
        error_messgae = 'The ShoppingCart catalogue must be a Catalogue.'
        expect do
          ShoppingCart.new(
            catalogue: 'catalogue',
            delivery_cost_schedule: delivery_cost_schedule,
            offers: offers
          )
        end.to raise_error(ArgumentError, error_messgae)
      end
    end

    context 'when the delivery_cost_schedule is not a DeliveryCostSchedule' do
      it 'raises an error' do
        error_messgae = 'The ShoppingCart delivery_cost_schedule must be a DeliveryCostSchedule.'
        expect do
          ShoppingCart.new(
            catalogue: catalogue,
            delivery_cost_schedule: 'delivery_cost_schedule',
            offers: offers
          )
        end.to raise_error(ArgumentError, error_messgae)
      end
    end

    context 'when the offers is not an array of Offers' do
      it 'raises an error' do
        error_messgae = 'The ShoppingCart offers must be an array of Offers.'
        expect do
          ShoppingCart.new(
            catalogue: catalogue,
            delivery_cost_schedule: delivery_cost_schedule,
            offers: 'offers'
          )
        end.to raise_error(ArgumentError, error_messgae)
      end
    end
  end

  describe '#add' do
    context 'when given a product code that is not in the catalogue' do
      it 'raises an error' do
        error_messgae = 'Only products in the catalogue can be added to the shopping cart.'
        expect { shopping_cart.add('bad code') }.to raise_error(ArgumentError, error_messgae)
      end
    end

    context 'when given a product code that is in the catalogue' do
      it 'adds the matching product to the basket' do
        expect(shopping_cart.basket.products.count).to eq(0)
        shopping_cart.add(jeans.code)
        expect(shopping_cart.basket.products).to include(jeans)
      end
    end
  end

  describe '#empty!' do
    it 'delegates to Basket#empty!' do
      expect(shopping_cart.basket).to receive(:empty!)
      shopping_cart.empty!
    end
  end

  describe '#total' do
    context 'when nothing modifies the total' do
      it 'returns the sum of the product prices and the base delivery cost' do
        shopping_cart.add(socks.code)
        shopping_cart.add(blouse.code)
        expect(shopping_cart.total).to eq('£37.85')
      end
    end

    context 'when an offer can be applied' do
      it 'returns the sum of the product prices and base delivery cost less the offer discount' do
        2.times { shopping_cart.add(jeans.code) }
        expect(shopping_cart.total).to eq('£54.37')
      end
    end

    context 'when a discounted shipping cost tier is reached' do
      it 'returns the sum of the product prices and discounted delivery cost' do
        shopping_cart.add(jeans.code)
        shopping_cart.add(blouse.code)
        expect(shopping_cart.total).to eq('£60.85')
      end
    end

    context 'when an offer can be applied and discounted shipping cost tier is reached' do
      it 'returns the sum of the product prices and discounted delivery cost ' \
         'less the offer discount' do
        2.times { shopping_cart.add(socks.code) }
        3.times { shopping_cart.add(jeans.code) }
        expect(shopping_cart.total).to eq('£98.27')
      end
    end
  end
end
