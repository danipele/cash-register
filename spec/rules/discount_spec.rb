require 'yaml'

require_relative '../../rules/discount'
require_relative '../../resources/product'

RSpec.describe Discount do
  before do
    allow(YAML).to receive(:load_file).with('data/products.yml').and_return(yaml_products)
  end

  let(:described_instance) { described_class.new(products, params) }
  let(:yaml_products) { { 'product2' => { 'name' => 'name2', 'price' => '10.00', 'rules' => rules } } }

  describe '#apply' do
    subject { described_instance.apply }

    let(:products) { [Product.new('product2'), Product.new('product2'), Product.new('product2')] }
    let(:params) { { 'buy' => buy, 'new_price' => new_price } }
    let(:rules) { [{ 'type' => 'discount', 'params' => params }] }

    context 'when rule start applying' do
      let(:buy) { 3 }
      let(:new_price) { 8.00 }

      it 'should apply to all products' do
        expect_any_instance_of(Discount).to receive(:apply_for_all_products).once
        subject
      end

      it 'should change all the prices to the new one' do
        subject
        expect(described_instance.products.select { |p| p.id == 'product2' }.map(&:price).uniq).to eq([8.00])
      end
    end

    context 'when rule is already applied for the other products' do
      let(:buy) { 2 }
      let(:new_price) { 8.00 }

      it 'should apply only for the last product' do
        expect_any_instance_of(Discount).to receive(:apply_for_last_product).once
        subject
      end
    end

    context 'when the price is a fraction' do
      let(:buy) { 3 }
      let(:new_price) { '3/4' }

      it 'should change all the prices to the new one correctly' do
        subject
        expect(described_instance.products.select { |p| p.id == 'product2' }.map(&:price).uniq).to eq([7.50])
      end
    end
  end
end
