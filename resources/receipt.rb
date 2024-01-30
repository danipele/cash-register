require_relative 'product'

class Receipt
  attr_accessor :products, :price

  def initialize
    @products = []
    @price = 0
  end

  def add_product(product)
    return unless product.instance_of?(Product)

    @products << product
    product.apply_rules(@products)
  end

  def display
    puts 'Receipt'
    puts 'Code | Name | Price'
    @products.each do |product|
      puts "#{product.id} | #{product.name} | #{product.price.round(2)}"
    end
  end
end
