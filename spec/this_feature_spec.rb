RSpec.describe ThisFeature do

  let(:fake_adapter) { described_class::Adapters::Fake }
  let(:flipper_adapter) { described_class::Adapters::Flipper }
  let(:adapters) { [fake_adapter] }
  let(:flag_name) { :made_up_flag }

  it "has a version number" do
    expect(described_class::VERSION).not_to be nil
  end

  describe '.adapter_for' do
    subject(:returned_adapter) { described_class.adapter_for(flag_name) }

    let(:fake_adapter_presence) { false }
    let(:flipper_adapter_presence) { true }

    before do
      described_class.configure do |configuration|
        configuration.adapters = adapters
      end

      allow(fake_adapter).to receive(:present?).and_return(fake_adapter_presence)
      allow(flipper_adapter).to receive(:present?).and_return(flipper_adapter_presence)
    end

    it 'returns default adapter if no matching adapter is found' do
      expect(subject).to eq(fake_adapter)
    end

    context 'with single matching adapter' do
      let(:adapters) { [fake_adapter, flipper_adapter] }

      it 'returns the matching adapter' do
        expect(subject).to eq(flipper_adapter)
      end
    end

    context 'with multiple matching adapters' do
      let(:adapters) { [fake_adapter, flipper_adapter] }

      let(:fake_adapter_presence) { true }

      it 'returns first matching adapter when multiple matches' do
        expect(subject).to eq(fake_adapter)
      end
    end
  end

  describe ".configure" do
    let(:adapters) { [fake_adapter, flipper_adapter] }
    let(:bad_adapter) { described_class::Adapters::Base }
    let(:bad_adapters) { [bad_adapter] }
    it "has setter which calls .setup on each adapter" do
      adapters.each do |adapter|
        expect(adapter).to receive(:setup)
      end
      described_class.configure do |configuration|
        configuration.adapters = adapters
      end
      expect(described_class.adapters).to eq(adapters)
    end
    it "wont accept any adapter that doesn't inherit from Base" do
      expect do
        described_class.configure do |configuration|
          configuration.adapters = bad_adapters
        end
      end.to raise_error(described_class::BadAdapterError) do |err|
        expect(err.message).to eq(
          "adapter #{bad_adapter.name} doesn't inherit from ThisFeature::Adapters::Base"
        )
      end
    end
  end

  describe ".flag" do
    before do
      described_class.configure do |configuration|
        configuration.adapters = adapters
      end
      allow(fake_adapter).to(
        receive(:present?).with(any_args).and_return true
      )
    end

    let(:context) { "foo" }
    let(:data) { "bar" }
    let(:opts) { { context: context, data: data } }

    subject(:flag) { described_class.flag(flag_name, **opts) }

    it "returns a new flag object with the matched adapter" do
      expect(flag.adapter).to eq(fake_adapter)
      expect(flag.flag_name).to eq(flag_name)
      expect(flag.context).to eq(context)
      expect(flag.data).to eq(data)
    end
  end
end
