# frozen_string_literal: true

require 'spec_helper'
require_relative '../lib/offer'

RSpec.describe Offer do
  let(:offer) { Offer.new(product_code: 'P01', threshold: 3, discount_in_units: 1) }
  let(:product) { Product.new(name: 'Prod', code: 'P01', price: 1) }
  let(:alternative_product) { Product.new(name: 'Prod 2', code: 'P02', price: 2) }

  let(:threshold_error_message) { "An Offer's threshold must be a positive integer." }
  let(:discount_error_message) { "An Offer's discount_in_units must be a positive number." }
  let(:comparison_error_message) { "An Offer's discount_in_units must be less than the threshold." }

  describe 'parameter validation' do
    context 'when the parameters are valid' do
      it 'does not raise an error' do
        expect { Offer.new(product_code: 'P01', threshold: 3, discount_in_units: 1) }
          .to_not raise_error
      end
    end

    context 'when the threshold is not a number' do
      it 'raises an error' do
        expect { Offer.new(product_code: 'P01', threshold: '3', discount_in_units: 1) }
          .to raise_error(ArgumentError, threshold_error_message)
      end
    end

    context 'when the threshold is a negative number' do
      it 'raises an error' do
        expect { Offer.new(product_code: 'P01', threshold: -3, discount_in_units: 1) }
          .to raise_error(ArgumentError, threshold_error_message)
      end
    end

    context 'when the threshold is zero' do
      it 'raises an error' do
        expect { Offer.new(product_code: 'P01', threshold: 0, discount_in_units: 1) }
          .to raise_error(ArgumentError, threshold_error_message)
      end
    end

    context 'when the discount_in_units is not a number' do
      it 'raises an error' do
        expect { Offer.new(product_code: 'P01', threshold: 3, discount_in_units: '1') }
          .to raise_error(ArgumentError, discount_error_message)
      end
    end

    context 'when the discount_in_units is a negative number' do
      it 'raises an error' do
        expect { Offer.new(product_code: 'P01', threshold: 3, discount_in_units: -1) }
          .to raise_error(ArgumentError, discount_error_message)
      end
    end

    context 'when the discount_in_units is zero' do
      it 'raises an error' do
        expect { Offer.new(product_code: 'P01', threshold: 3, discount_in_units: 0) }
          .to raise_error(ArgumentError, discount_error_message)
      end
    end

    context 'when the discount_in_units is greater than or equal to the threshold' do
      it 'raises an error' do
        expect { Offer.new(product_code: 'P01', threshold: 3, discount_in_units: 4) }
          .to raise_error(ArgumentError, comparison_error_message)

        expect { Offer.new(product_code: 'P01', threshold: 3, discount_in_units: 3) }
          .to raise_error(ArgumentError, comparison_error_message)
      end
    end
  end

  describe '#evaluate_products' do
    context 'when given anything other than an array of products' do
      it 'raises an error' do
        expect { offer.evaluate_products(products: 'products') }
          .to raise_error(ArgumentError, 'Only an array of Products can be evaluated by an Offer.')

        expect { offer.evaluate_products(products: ['products']) }
          .to raise_error(ArgumentError, 'Only an array of Products can be evaluated by an Offer.')
      end
    end

    context 'when given an array of products' do
      context 'and the products are insufficient to trigger the offer' do
        it 'returns an unmodified list of products and cost of 0' do
          products = [product] * 2
          expect(offer.evaluate_products(products: products)).to eq([products, 0])

          products += [alternative_product] * 2
          expect(offer.evaluate_products(products: products)).to eq([products, 0])
        end
      end

      context 'and the products are sufficient to trigger the offer' do
        context 'and there are exactly enough products to trigger the offer' do
          it 'returns an empty list of products and the cost of the offer' do
            products = [product] * 3
            expect(offer.evaluate_products(products: products)).to eq([[], 2])
          end
        end

        context 'and there are additional products after applying the offer' do
          it 'returns an array of the remaining products and the cost of the offer' do
            products = [product] * 4
            expect(offer.evaluate_products(products: products)).to eq([[product], 2])
          end
        end
      end
    end
  end
end
