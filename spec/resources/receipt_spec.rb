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

    it 'should display the total price' do
      subject
      expect(output_string.string).to include('Total price: ')
    end

    context 'when there is a product' do
      before do
        allow(YAML).to receive(:load_file).with('data/products.yml').and_return(products)
        described_instance.add_product(product)
      end

      let(:product) { Product.new('product1') }
      let(:products) { { 'product1' => { 'name' => 'name', 'price' => price, 'rules' => [] } } }
      let(:price) { '12.23' }

      it 'should display the product' do
        subject
        expect(output_string.string).to include('product1 | name | 12.23')
      end

      context 'when price has more than 2 decimals' do
        let(:price) { '12.233333333' }

        it 'should display the price with 2 decimals' do
          subject
          expect(output_string.string).to include('product1 | name | 12.23')
        end
      end

      it 'should display the total price correctly' do
        subject
        expect(output_string.string).to include('Total price: 12.23')
      end
    end

    context 'when there are multiple products' do
      before do
        allow(YAML).to receive(:load_file).with('data/products.yml').and_return(products)
        described_instance.add_product(product1)
        described_instance.add_product(product2)
      end

      let(:product1) { Product.new('product1') }
      let(:product2) { Product.new('product2') }
      let(:products) do
        {
          'product1' => { 'name' => 'name1', 'price' => '12.23', 'rules' => [] },
          'product2' => { 'name' => 'name2', 'price' => '10.00', 'rules' => [] }
        }
      end

      it 'should display all the products' do
        subject
        expect(output_string.string).to include('product1 | name1 | 12.23')
        expect(output_string.string).to include('product2 | name2 | 10.0')
      end

      it 'should display the total price correctly' do
        subject
        expect(output_string.string).to include('Total price: 22.23')
      end
    end
  end
end
