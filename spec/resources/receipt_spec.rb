require 'yaml'

require_relative '../../resources/receipt'

RSpec.describe Receipt do
  let(:described_instance) { described_class.new }

  describe '#new' do
    subject { described_instance }

    it 'should initialize products' do
      expect(subject.products).to eq([])
    end

    it 'should initialize price' do
      expect(subject.price).to eq(0)
    end
  end

  describe '#add_product' do
    subject { described_instance.add_product(product) }

    context 'when product is nil' do
      let(:product) { nil }

      it 'should not add the product' do
        subject
        expect(described_instance.products.count).to eq(0)
      end

      it 'should not apply the rules' do
        expect_any_instance_of(Product).not_to receive(:apply_rules)
        subject
      end
    end

    context 'when product is not a Product' do
      let(:product) { 0 }

      it 'should not add the product' do
        subject
        expect(described_instance.products.count).to eq(0)
      end

      it 'should not apply the rules' do
        expect_any_instance_of(Product).not_to receive(:apply_rules)
        subject
      end
    end

    context 'when product is valid' do
      before do
        allow(YAML).to receive(:load_file).with('data/products.yml').and_return(products)
      end

      let(:product) { Product.new('product1') }
      let(:products) { { 'product1' => { 'name' => 'name', 'price' => '12.23', 'rules' => [] } } }

      it 'should add the product' do
        subject
        expect(described_instance.products.count).to eq(1)
      end

      it 'should apply the rules' do
        expect_any_instance_of(Product).to receive(:apply_rules).with([product]).once
        subject
      end
    end
  end

  describe '#display' do
    subject { described_instance.display }

    before do
      allow(described_instance).to receive(:puts) { |msg| output_string.puts msg }
    end

    let(:output_string) { StringIO.new }

    it 'should display the title' do
      subject
      expect(output_string.string).to include('Receipt')
    end

    it 'should display the header' do
      subject
      expect(output_string.string).to include('Code | Name | Price')
    end

    context 'when there is a product' do
      before do
        allow(YAML).to receive(:load_file).with('data/products.yml').and_return(products)
        described_instance.add_product(product)
      end

      let(:product) { Product.new('product1') }
      let(:products) { { 'product1' => { 'name' => 'name', 'price' => '12.23', 'rules' => [] } } }

      it 'should display the product' do
        subject
        expect(output_string.string).to include('product1 | name | 12.23')
      end
    end
  end
end
