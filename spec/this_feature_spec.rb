RSpec.describe ThisFeature do

  let(:fake_adapter) { described_class::Adapters::Fake.new }
  let(:flipper_adapter) { described_class::Adapters::Flipper.new }
  let(:adapters) { [fake_adapter] }
  let(:flag_name) { :made_up_flag }

  it "has a version number" do
    expect(described_class::VERSION).not_to be nil
  end

  describe '.test_adapter' do
    it "delegates to configuration.test_adapter" do
      described_class.configuration.test_adapter = double("adapter")
      expect(described_class.test_adapter).to eq(described_class.configuration.test_adapter)
    end
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
    let(:bad_adapter) { described_class::Adapters::Base.new }
    let(:bad_adapters) { [bad_adapter] }

    it "raises an error if no adapters are given" do
      expect do
        described_class.configure {}
      end.to raise_error(described_class::NoAdaptersError) do |err|
        expect(err.message).to eq("No adapters configured.")
      end
    end

    it "wont accept any adapter that doesn't inherit from Base" do
      expect do
        described_class.configure do |configuration|
          configuration.adapters = bad_adapters
        end
      end.to raise_error(described_class::BadAdapterError) do |err|
        expect(err.message).to eq(
          "adapter #{bad_adapter.class.name} doesn't inherit from ThisFeature::Adapters::Base"
        )
      end
    end

    context "test_adapter" do
      it "defaults to a memory adapter" do
        described_class.configure do |config|
          config.test_adapter = nil # wipe out the value
          config.adapters = [config.test_adapter] # so the custom reader logic is used
        end
        expect(described_class.configuration.test_adapter).to be_a(
          described_class::Adapters::Memory
        )
      end

      it "can be set to a custom value" do
        adapter = described_class::Adapters::Memory.new
        described_class.configure do |config|
          config.test_adapter = adapter
          config.adapters = [adapter]
        end
        expect(described_class.configuration.test_adapter).to eq(adapter)
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
