require 'pry-byebug'

class InvalidProduct < StandardError; end

class Product
  attr_accessor :id, :name, :price

  def initialize(product_id)
    product = product_hash(product_id)
    raise InvalidProduct unless product

    @id = product_id
    @name = product['name']
    @price = product['price'].to_f
  end

  private

  def product_hash(product_id)
    YAML.load_file('data/products.yml')[product_id]
  end
end
