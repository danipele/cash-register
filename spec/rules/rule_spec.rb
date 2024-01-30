require 'yaml'

require_relative '../../rules/rule'
require_relative '../../resources/product'

RSpec.describe Rule do
  before do
    allow(YAML).to receive(:load_file).with('data/products.yml').and_return(yaml_products)
  end

  let(:described_instance) { described_class.new(products, params) }
  let(:yaml_products) do
    {
      'product1' => { 'name' => 'name', 'price' => '12.23', 'rules' => [] },
      'product2' => { 'name' => 'name2', 'price' => '10.00', 'rules' => [] }
    }
  end
  let(:products) { [Product.new('product2'), Product.new('product1')] }
  let(:params) { { 'param1' => 'value1' } }

  describe '#new' do
    subject { described_instance }

    it 'should initialize product with correct fields' do
      expect(subject.product.id).to eq('product1')
      expect(subject.product.name).to eq('name')
      expect(subject.product.price).to eq(12.23)
    end

    it 'should initialize products with correct fields' do
      expect(subject.products[0].id).to eq('product2')
      expect(subject.products[0].name).to eq('name2')
      expect(subject.products[0].price).to eq(10.0)
    end

    it 'should initialize params with correct fields' do
      expect(subject.params['param1']).to eq('value1')
    end
  end
end
