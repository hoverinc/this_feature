klass = FFeature

RSpec.describe klass do

it "has a version number" do
    expect(klass::VERSION).not_to be nil
  end

  describe ".adapters= setter" do
    it "has setter which calls .setup on each adapter" do
      new_val = [klass::Adapters::Flipper]
      new_val.each do |adapter|
        expect(adapter).to receive(:setup)
      end
      klass.set_adapters(new_val)
      expect(klass.adapters).to eq(new_val)
    end
    it "wont accept any adapter that doesn't inherit from Base" do
      bad_adapter = klass::Adapters::Base
      new_val = [bad_adapter]
      expect { klass.set_adapters(new_val) }.to raise_error(klass::BadAdapterError) do |err|
        expect(err.message).to eq(
          "adapter #{bad_adapter.name} doesn't inherit from FFeature::Adapters::Base"
        )
      end
    end
  end

  describe ".enabled?" do
    before(:all) do
      klass.set_adapters([
        klass::Adapters::Flipper,
        klass::Adapters::Fake
      ])
    end
    let(:flag_name) { "some flag" }
    context "queries each adapter until it gets a yes/no answer" do
      it "stops iterating if it gets a 'yes' answer" do
        expect(klass.adapters[0]).to receive(:enabled?).with(flag_name, context: nil).and_return true
        expect(klass.adapters[1]).not_to receive(:enabled?)
        expect(klass.enabled?(flag_name)).to eq(true)
      end
      it "returns nil if none of them give a yes/no answer" do
        expect(klass.adapters[0]).to receive(:enabled?).with(flag_name, context: nil).and_return nil
        expect(klass.adapters[1]).to receive(:enabled?).and_return nil
        expect(klass.enabled?(flag_name)).to eq(nil)
      end
      it "stops iterating if it gets a 'no' answer" do
        expect(klass.adapters[0]).to receive(:enabled?).with(flag_name, context: nil).and_return false
        expect(klass.adapters[1]).not_to receive(:enabled?)
        expect(klass.enabled?(flag_name)).to eq(false)
      end
    end
    context "when given a flag name and user" do
      let(:pseudo_user) { OpenStruct.new(flipper_id: 1) }
      it "passes along the user argument to the individual adapters" do
        expect(klass.adapters[0]).to receive(:enabled?).with(flag_name, context: pseudo_user).and_return true
        expect(klass.adapters[1]).not_to receive(:enabled?)
        expect(klass.enabled?(flag_name, context: pseudo_user)).to eq(true)
      end
    end
  end
end
