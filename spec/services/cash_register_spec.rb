require_relative '../../services/cash_register'

RSpec.describe CashRegister do
  describe '#register' do
    subject { described_class.register }

    context 'when stop scanning' do
      before do
        allow(Scanner).to receive(:scan_product) { raise StopScanning }
      end

      it 'should create a receipt' do
        expect(Receipt).to receive(:new).once
        subject
      end

      it 'should stop scanning' do
        expect_any_instance_of(Receipt).not_to receive(:display)
        subject
      end
    end

    context 'when scan once' do
      before do
        scanned = false
        allow(Scanner).to receive(:scan_product) do
          raise StopScanning if scanned

          scanned = true
          double_product
        end
      end

      let(:double_product) { double(:product) }

      it 'should add the product to the receipt' do
        expect_any_instance_of(Receipt).to receive(:add_product).with(double_product).once
        subject
      end

      it 'should display the receipt' do
        expect_any_instance_of(Receipt).to receive(:display).once
        subject
      end
    end
  end
end
