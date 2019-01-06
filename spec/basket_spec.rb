# frozen_string_literal: true

require 'spec_helper'
require_relative '../lib/basket'

RSpec.describe Basket do
  let(:basket) { Basket.new }
  let(:product) { Product.new(name: 'Prod', code: 'P01', price: 1) }
  let(:offers) { [Offer.new(product_code: 'P01', threshold: 3, discount_in_units: 1)] }

  describe '#add' do
    it 'responds to #add' do
      expect(basket).to respond_to(:add)
    end

    it 'responds to #<< as an alias for #add' do
      expect(basket).to respond_to(:<<)
      expect(basket.method(:add)).to eq(basket.method(:<<))
    end

    context 'when adding a product' do
      it 'does not raise an error' do
        expect { basket.add(product) }.to_not raise_error
      end

      it 'is included in the list of products' do
        basket.add(product)
        expect(basket.products).to include(product)
      end
    end

    context 'when adding something other than a product' do
      it 'raises an error' do
        expect { basket.add('product') }
          .to raise_error(ArgumentError, 'A Basket can only include Products.')
      end
    end
  end

  describe '#products' do
    it 'returns an array of all the products in the basket' do
      num_products = 3
      num_products.times { basket << product }
      expect(basket.products.count).to eq(num_products)
    end
  end

  describe '#empty!' do
    it 'resets the list of products' do
      num_products = 3
      num_products.times { basket << product }
      expect(basket.products.count).to eq(num_products)
      basket.empty!
      expect(basket.products.count).to eq(0)
    end
  end

  describe '#total' do
    context 'when given anything other than an array of offers' do
      it 'raises an error' do
        expect { basket.total(offers: 'offers') }
          .to raise_error(ArgumentError, "Only an array of Offers can modify a Basket's total.")

        expect { basket.total(offers: ['offers']) }
          .to raise_error(ArgumentError, "Only an array of Offers can modify a Basket's total.")
      end
    end

    context 'when given an empty array or nothing at all' do
      it 'does not raise an error' do
        expect { basket.total }.to_not raise_error
        expect { basket.total(offers: []) }.to_not raise_error
      end

      it 'returns an unmodified total cost of the products' do
        num_products = 3
        num_products.times { basket << product }
        expect(basket.total).to eq(basket.products.map(&:price).reduce(&:+))
        expect(basket.products.count).to eq(num_products)
      end
    end

    context 'when given an array of offers' do
      it 'does not raise an error' do
        expect { basket.total(offers: offers) }.to_not raise_error
      end

      it 'returns a total cost of the products modified by the given offers' do
        num_products = 3
        num_products.times { basket << product }
        expect(basket.total(offers: offers)).to eq(([product] * 2).map(&:price).reduce(&:+))
        expect(basket.products.count).to eq(num_products)
      end

      context 'when multiple offers can be applied' do
        it 'returns a total cost of the products modified by all applicable offers' do
          num_products = 7
          num_products.times { basket << product }
          expect(basket.total(offers: offers)).to eq(([product] * 5).map(&:price).reduce(&:+))
          expect(basket.products.count).to eq(num_products)
        end
      end
    end
  end
end
