require_relative '../../services/scanner'
require_relative '../../resources/product'

RSpec.describe Scanner do
  before do
    allow(described_class).to receive(:puts) { |msg| output_string.puts msg }
  end

  let(:output_string) { StringIO.new }

  describe '#scan_product' do
    subject { described_class.scan_product }

    before do
      allow(YAML).to receive(:load_file).with('data/products.yml').and_return(products)
      allow(described_class).to receive(:gets).and_return(input_string)
    end

    let(:products) { { 'product1' => {}, 'product2' => {} } }
    let(:input_string) { 'product1' }

    it 'should display the intro text' do
      subject
      expect(output_string.string).to include("Scan a product: (#{products.keys.join(',')}) or press q to quit")
    end

    it 'should not stop scanning' do
      expect { subject }.not_to raise_error(StopScanning)
    end

    it 'should create a product' do
      expect(Product).to receive(:new).with(input_string).once
      subject
    end

    context 'when press q' do
      let(:input_string) { 'q' }

      it 'should raise the error' do
        expect { subject }.to raise_error(StopScanning)
      end
    end

    context 'when invalid product' do
      before do
        allow(YAML).to receive(:load_file).with('data/products.yml').and_return(products)
        allow(described_class).to receive(:gets).and_return('invalid_product', 'q')
      end

      it 'should display the message' do
        expect { subject }.to raise_error(StopScanning)
        expect(output_string.string).to include('Invalid product. Try again!')
      end
    end
  end
end
