require_relative '../resources/receipt'
require_relative '../services/scanner'

class CashRegister
  def self.register
    receipt = Receipt.new

    loop do
      product = Scanner.scan_product

      receipt.add_product(product)
      receipt.display
    rescue StopScanning
      break
    end
  end
end
