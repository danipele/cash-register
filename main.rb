require_relative 'services/scanner'
require_relative 'resources/receipt'
require_relative 'resources/product'

def scan_product
  product_id = Scanner.scan
  Product.new(product_id)
rescue InvalidProduct => _e
  puts 'Invalid product'
  scan_product
end

def go
  receipt = Receipt.new

  loop do
    product = scan_product

    receipt.add_product(product)
    receipt.display

    break if Scanner.stop_scanning?
  end
end

go
