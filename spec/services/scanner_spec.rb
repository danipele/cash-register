require_relative '../../services/scanner'

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
      expect(output_string.string).to include("Scan a product: (#{products.keys.join(',')}) or press q to quit")
    end

    it 'should read a line' do
      expect(subject).to eq(input_string.chomp)
    end
  end
end
