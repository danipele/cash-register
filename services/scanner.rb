require 'yaml'

class StopScanning < StandardError; end

class Scanner
  class << self
    def scan_product
      product_id = scan
      raise StopScanning if product_id == 'q'

      Product.new(product_id)
    rescue InvalidProduct => _e
      puts "Invalid product. Try again!\n\n"
      scan_product
    end

    def scan
      puts "Scan a product: (#{products.join(',')}) or press q to quit"
      gets.chomp
    end

    def products
      YAML.load_file('data/products.yml').keys
    end
  end
  private_class_method :products, :scan
end
