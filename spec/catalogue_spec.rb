# frozen_string_literal: true

require 'spec_helper'
require_relative '../lib/catalogue'

RSpec.describe Catalogue do
  let(:catalogue) { Catalogue.new }
  let(:product) { Product.new(name: 'Prod', code: 'P01', price: 1) }
  let(:duplicate_product) { Product.new(name: 'Diplicate Prod', code: 'P01', price: 1) }

  describe '#add' do
    it 'responds to #add' do
      expect(catalogue).to respond_to(:add)
    end

    it 'responds to #<< as an alias for #add' do
      expect(catalogue).to respond_to(:<<)
      expect(catalogue.method(:add)).to eq(catalogue.method(:<<))
    end

    context 'when adding a product' do
      it 'does not raise an error' do
        expect { catalogue.add(product) }.to_not raise_error
      end

      it 'is included in the list of products' do
        catalogue.add(product)
        expect(catalogue.products).to include(product)
      end

      context 'and the prodcut code already exists' do
        it 'raises an error' do
          catalogue.add(product)
          expect { catalogue.add(duplicate_product) }
            .to raise_error(ArgumentError, 'Products in a catalogue must have unique codes.')
        end
      end
    end

    context 'when adding something other than a product' do
      it 'raises an error' do
        expect { catalogue.add('product') }
          .to raise_error(ArgumentError, 'A Catalogue can only include Products.')
      end
    end
  end

  describe '#includes_code?' do
    context 'when given a code matching a product in the catalogue' do
      it 'returns true' do
        catalogue.add(product)
        expect(catalogue.includes_code?(product.code)).to eq(true)
      end
    end

    context "when given a code that doesn't match a product in the catalogue" do
      it 'returns false' do
        catalogue.add(product)
        expect(catalogue.includes_code?('bad_code')).to eq(false)
      end
    end
  end

  describe '#product_by_code' do
    it "returns the product matching the given code or nil if the product can't be matched" do
      catalogue.add(product)
      expect(catalogue.product_by_code(product.code)).to eq(product)
      expect(catalogue.product_by_code('bad_code')).to eq(nil)
    end
  end
end
