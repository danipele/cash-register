require 'yaml'

class Scanner
  def self.scan
    puts "Scan a product: (#{products.join(',')}) or press q to quit"
    gets.chomp
  end

  def self.products
    YAML.load_file('data/products.yml').keys
  end

  private_class_method :products
end
