RSpec.describe ThisFeature::Flag do
  let(:fake_adapter) { ThisFeature::Adapters::Fake }
  let(:flag_name) { 'a_flag' }
  let(:context) { 'foo' }
  let(:data) { 'bar' }

  let(:expected_return) { [true, false].sample }

  let(:flag) { described_class.new(flag_name, adapter: fake_adapter, data: data, context: context) }

  describe '#on?' do
    subject { flag.on? }

    before do
      expect(fake_adapter).to receive(:on?).with(flag_name, data: data, context: context).and_return(expected_return)
    end

    it { is_expected.to be(expected_return) }
  end

  describe '#off?' do
    subject { flag.off? }

    before do
      expect(fake_adapter).to receive(:off?).with(flag_name, data: data, context: context).and_return(expected_return)
    end

    it { is_expected.to be(expected_return) }
  end

  describe '#control?' do
    subject { flag.control? }

    before do
      expect(fake_adapter).to receive(:control?).with(flag_name, data: data, context: context).and_return(expected_return)
    end

    it { is_expected.to be(expected_return) }
  end

  describe '#on!' do
    subject { flag.on! }

    before do
      expect(fake_adapter).to receive(:on!).with(flag_name, data: data, context: context).and_return(expected_return)
    end

    it { is_expected.to be(expected_return) }
  end

  describe '#off!' do
    subject { flag.off! }

    before do
      expect(fake_adapter).to receive(:off!).with(flag_name, data: data, context: context).and_return(expected_return)
    end

    it { is_expected.to be(expected_return) }
  end
end
