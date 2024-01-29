require_relative 'scanner'
require_relative 'receipt'
require_relative 'product'

receipt = Receipt.new

loop do
  product_id = Scanner.scan
  product = Product.new(product_id)
  receipt.add_product(product)
  receipt.display

  break if Scanner.stop_scanning?
end
