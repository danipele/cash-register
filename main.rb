require_relative 'services/scanner'
require_relative 'resources/receipt'
require_relative 'resources/product'

class StopScanning < StandardError; end

def scan_product
  scan = Scanner.scan
  raise StopScanning if scan == 'q'

  Product.new(scan)
rescue InvalidProduct => _e
  puts "Invalid product. Try again!\n\n"
  scan_product
end

def go
  receipt = Receipt.new

  loop do
    product = scan_product

    receipt.add_product(product)
    receipt.display
  rescue StopScanning
    break
  end
end

go
