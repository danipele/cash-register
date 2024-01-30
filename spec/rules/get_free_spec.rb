require 'yaml'

require_relative '../../rules/get_free'
require_relative '../../resources/product'

RSpec.describe GetFree do
  before do
    allow(YAML).to receive(:load_file).with('data/products.yml').and_return(yaml_products)
  end

  let(:described_instance) { described_class.new(product, products, params) }
  let(:yaml_products) do
    {
      'product1' => { 'name' => 'name', 'price' => '12.23', 'rules' => [] },
      'product2' => { 'name' => 'name2', 'price' => '10.00', 'rules' => rules }
    }
  end

  describe '#apply' do
    subject { described_instance.apply }

    let(:product) { Product.new('product2') }
    let(:products) { [Product.new('product1'), Product.new('product2')] }
    let(:params) { { 'buy' => buy, 'free' => 2 } }
    let(:rules) { [{ 'type' => 'get_free', 'params' => params }] }

    context 'when the limit is not reached' do
      let(:buy) { 2 }

      it 'should not add any more products' do
        subject
        expect(described_instance.products.count).to eq(2)
      end
    end

    context 'when the limit is reached' do
      let(:buy) { 1 }

      it 'should add more products' do
        subject
        expect(described_instance.products.count).to eq(4)
      end
    end
  end
end
