require_relative 'rule'

class Discount < Rule
  def apply
    if product_count == buy
      apply_for_all_products
    elsif product_count > buy
      apply_for_last_product
    end
  end

  private

  def apply_for_all_products
    applying_products.each { |p| apply_price(p) }
  end

  def apply_for_last_product
    apply_price(applying_products.last)
  end

  def apply_price(product)
    product.price = if new_price.instance_of?(Float)
                      new_price.to_f
                    elsif new_price.include?('/')
                      apply_fraction(product)
                    end
  end

  def apply_fraction(product)
    a, b = new_price.split('/')

    a.to_f * product.price / b.to_f
  end

  def new_price
    @params['new_price']
  end
end
