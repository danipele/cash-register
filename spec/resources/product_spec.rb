require 'yaml'

require_relative '../../resources/product'

RSpec.describe Product do
  before do
    allow(YAML).to receive(:load_file).with('data/products.yml').and_return(products)
  end

  let(:described_instance) { described_class.new(product_id) }
  let(:product_id) { 'product1' }
  let(:products) { { 'product1' => { 'name' => 'name', 'price' => '12.23', 'rules' => rules } } }

  describe '#new' do
    subject { described_instance }

    let(:rules) { [{ 'type' => 'get_free', 'params' => { 'buy' => 1, 'free' => 1 } }] }

    it 'should initialize name with correct value' do
      expect(subject.name).to eq('name')
    end

    it 'should initialize price with correct value' do
      expect(subject.price).to eq(12.23)
    end

    it 'should initialize rules with correct value' do
      expect(subject.rules).to eq([{ 'type' => 'get_free', 'params' => { 'buy' => 1, 'free' => 1 } }])
    end

    context 'when invalid product' do
      let(:product_id) { 'invalid_product' }

      it 'should raise an error' do
        expect { subject }.to raise_error(InvalidProduct)
      end
    end
  end

  describe '#apply_rules' do
    subject { described_instance.apply_rules([]) }

    context 'when rules is nil' do
      let(:rules) { nil }

      it 'should not apply the rule' do
        expect(GetFree).not_to receive(:new)
        expect_any_instance_of(GetFree).not_to receive(:apply)
        subject
      end
    end

    context 'when no rule' do
      let(:rules) { [] }

      it 'should not apply the rule' do
        expect(GetFree).not_to receive(:new)
        expect_any_instance_of(GetFree).not_to receive(:apply)
        subject
      end
    end

    context 'when invalid rule' do
      let(:rules) { [{ 'type' => 'invalid_type', 'params' => { 'param1' => 1, 'params2' => false } }] }

      it 'should not apply the rule' do
        expect(GetFree).not_to receive(:new)
        expect_any_instance_of(GetFree).not_to receive(:apply)
        subject
      end
    end

    context 'when valid rule' do
      let(:rules) { [{ 'type' => 'get_free', 'params' => { 'buy' => 1, 'free' => 1 } }] }
      let(:rule_double) { double(:rule, apply: nil) }

      it 'should apply the rule' do
        expect(GetFree).to receive(:new).and_return(rule_double).once
        expect(rule_double).to receive(:apply).once
        subject
      end
    end

    context 'when multiple rules' do
      let(:rules) do
        [
          { 'type' => 'get_free', 'params' => { 'buy' => 1, 'free' => 1 } },
          { 'type' => 'invalid', 'params' => { 'buy' => 1, 'free' => 1 } },
          { 'type' => 'get_free', 'params' => { 'buy' => 1, 'free' => 1 } }
        ]
      end
      let(:rule_double) { double(:rule, apply: nil) }

      it 'should apply the rules' do
        expect(GetFree).to receive(:new).and_return(rule_double).twice
        expect(rule_double).to receive(:apply).twice
        subject
      end
    end
  end
end
