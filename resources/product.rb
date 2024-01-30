require_relative '../rules/get_free'
require_relative '../rules/discount'

class InvalidProduct < StandardError; end

class Product
  attr_accessor :id, :name, :price, :rules

  def initialize(product_id)
    product = product_hash(product_id)
    raise InvalidProduct unless product

    @id = product_id
    @name = product['name']
    @price = product['price'].to_f
    @rules = product['rules'] || []
  end

  def apply_rules(products)
    @rules.each do |rule|
      apply_rule(rule['type'], rule['params'], products)
    end
  end

  private

  def product_hash(product_id)
    YAML.load_file('data/products.yml')[product_id]
  end

  def apply_rule(rule_type, params, products)
    case rule_type
    when 'get_free'
      rule = GetFree.new(products, params)
    when 'discount'
      rule = Discount.new(products, params)
    else
      return
    end

    rule.apply
  end
end
