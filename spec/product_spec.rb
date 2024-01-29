require_relative '../product'

RSpec.describe Product do
  describe '#new' do
    subject { described_class.new(product_id) }

    before do
      allow(YAML).to receive(:load_file).with('data/products.yml').and_return(products)
    end

    let(:product_id) { 'product1' }
    let(:products) { { 'product1' => { 'name' => 'name', 'price' => '12.23' } } }

    it 'should initialize name with correct value' do
      expect(subject.name).to eq('name')
    end

    it 'should initialize price with correct value' do
      expect(subject.price).to eq(12.23)
    end
  end
end
