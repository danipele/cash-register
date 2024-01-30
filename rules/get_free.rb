require_relative 'rule'

class GetFree < Rule
  def apply
    add_free_products if buy_limit
  end

  private

  def free
    @params['free'].to_i
  end

  def add_free_products
    product = Product.new(@product.id)
    product.price = 0

    free.times { @products << product }
  end

  def buy_limit
    product_count % (buy + free) == buy
  end
end
