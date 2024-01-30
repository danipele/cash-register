class Rule
  attr_accessor :product, :products, :params

  def initialize(product, products, params)
    @product = product
    @products = products
    @params = params
  end

  def apply; end

  protected

  def product_count
    @products.count { |p| p.id == @product.id }
  end

  def buy
    @params['buy'].to_i
  end
end
