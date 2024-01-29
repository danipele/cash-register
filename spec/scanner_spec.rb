require_relative '../scanner'

RSpec.describe Scanner do
  before do
    allow(described_class).to receive(:puts) { |msg| output_string.puts msg }
  end

  let(:output_string) { StringIO.new }

  describe '#scan' do
    subject { described_class.scan }

    before do
      allow(YAML).to receive(:load_file).with('data/products.yml').and_return(products)
      allow(described_class).to receive(:gets).and_return(input_string)
    end

    let(:products) { { 'product1' => {}, 'product2' => {} } }
    let(:input_string) { "product_id\n" }

    it 'should display the intro text' do
      subject
      expect(output_string.string).to include("Scan a product: (#{products.keys.join(',')})")
    end

    it 'should read a line' do
      expect(subject).to eq(input_string.chomp)
    end
  end

  describe '#stop_scanning' do
    subject { described_class.stop_scanning? }

    context 'when press a valid answer' do
      before do
        allow(described_class).to receive(:gets).and_return(input_string)
      end

      context 'when n' do
        let(:input_string) { 'n' }

        it 'should display the intro text' do
          subject
          expect(output_string.string).to include('Do you have more products to scan? (y = yes, n = no)')
        end

        it 'should return true' do
          expect(subject).to eq(true)
        end

        it 'should not display the invalid answer message' do
          subject
          expect(output_string.string).not_to include('Invalid answer')
        end
      end

      context 'when y' do
        let(:input_string) { 'y' }

        it 'should display the intro text' do
          subject
          expect(output_string.string).to include('Do you have more products to scan? (y = yes, n = no)')
        end

        it 'should return false' do
          expect(subject).to eq(false)
        end

        it 'should not display the invalid answer message' do
          subject
          expect(output_string.string).not_to include('Invalid answer')
        end
      end
    end

    context 'when press something else' do
      before do
        allow(described_class).to receive(:gets).and_return('q', 'n')
      end

      it 'should display the intro text' do
        subject
        expect(output_string.string).to include('Do you have more products to scan? (y = yes, n = no)')
      end

      it 'should display the invalid answer message' do
        subject
        expect(output_string.string).to include('Invalid answer')
      end
    end
  end
end
