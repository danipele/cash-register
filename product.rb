require 'pry-byebug'

class Product
  attr_accessor :id, :name, :price

  def initialize(product_id)
    product = product_hash(product_id)

    @id = product_id
    @name = product['name']
    @price = product['price'].to_f
  end

  private

  def product_hash(product_id)
    YAML.load_file('data/products.yml')[product_id]
  end
end
