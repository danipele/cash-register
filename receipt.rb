require_relative 'product'
require 'pry-byebug'

class Receipt
  attr_accessor :products, :price

  def initialize
    @products = []
    @price = 0
  end

  def add_product(product)
    return unless product.instance_of?(Product)

    @products << product
  end

  def display
    puts 'Receipt'
    puts 'Code | Name | Price'
    @products.each do |product|
      puts "#{product.id} | #{product.name} | #{product.price}"
    end
  end

  private

  def product_hash
    YAML.load_file('data/products.yml')[prod]
  end
end
