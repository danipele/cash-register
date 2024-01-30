class Rule
  attr_accessor :product, :products, :params

  def initialize(products, params)
    @product = products.last
    @products = products
    @params = params
  end

  def apply; end

  protected

  def product_count
    applying_products.count
  end

  def applying_products
    @products.select { |p| p.id == @product.id }
  end

  def buy
    @params['buy'].to_i
  end
end
