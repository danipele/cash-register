require 'yaml'

class Scanner
  def self.scan
    puts "Scan a product: (#{products.join(',')})"
    gets.chomp
  end

  def self.stop_scanning?
    puts 'Do you have more products to scan? (y = yes, n = no)'

    case gets.chomp
    when 'n'
      true
    when 'y'
      false
    else
      puts 'Invalid answer'
      stop_scanning?
    end
  end

  def self.products
    YAML.load_file('data/products.yml').keys
  end

  private_class_method :products
end
