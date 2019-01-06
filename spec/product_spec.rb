# frozen_string_literal: true

require 'spec_helper'
require_relative '../lib/product'

RSpec.describe Product do
  let(:error_message) { "A Product's price must be a positive number." }

  context 'when the parameters are valid' do
    it 'does not raise an error' do
      expect { Product.new(name: 'Prod', code: 'P01', price: 1) }.to_not raise_error
    end
  end

  context 'when the price is not a number' do
    it 'raises an error' do
      expect { Product.new(name: 'Prod', code: 'P01', price: '1') }
        .to raise_error(ArgumentError, error_message)
    end
  end

  context 'when the price is a negative number' do
    it 'raises an error' do
      expect { Product.new(name: 'Prod', code: 'P01', price: -1) }
        .to raise_error(ArgumentError, error_message)
    end
  end

  context 'when the price is zero' do
    it 'raises an error' do
      expect { Product.new(name: 'Prod', code: 'P01', price: 0) }
        .to raise_error(ArgumentError, error_message)
    end
  end
end
