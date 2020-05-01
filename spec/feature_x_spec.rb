klass = FeatureX

RSpec.describe klass do

it "has a version number" do
    expect(klass::VERSION).not_to be nil
  end

  describe ".adapters getter" do
    it "returns value of class-level instance variable" do
      klass.instance_variable_set "@adapters", 123
      expect(klass.adapters).to eq(123)
    end
    it "has a default return value" do
      klass.instance_variable_set "@adapters", nil
      expect(klass.adapters).to eq([])
    end
  end

  describe ".adapters= setter" do
    it "has setter which calls .setup on each adapter" do
      new_val = [klass::Adapters::FlipperAdapter]
      new_val.each do |adapter|
        expect(adapter).to receive(:setup)
      end
      klass.set_adapters(new_val)
      expect(klass.adapters).to eq(new_val)
    end
    it "wont accept any adapter that doesn't inherit from BaseAdapter" do
      bad_adapter = klass::Adapters::BaseAdapter
      new_val = [bad_adapter]
      expect { klass.set_adapters(new_val) }.to raise_error(klass::BadAdapterError) do |err|
        expect(err.message).to eq(
          "adapter #{bad_adapter.name} doesn't inherit from FeatureX::Adapters::BaseAdapter"
        )
      end
    end
  end

  describe ".enabled?" do
    before(:all) do
      klass.set_adapters([
        klass::Adapters::FlipperAdapter,
        klass::Adapters::FakeAdapter
      ])
    end
    let(:flag_name) { "some flag" }
    context "queries each adapter until it gets a yes/no answer" do
      it "stops iterating if it gets a 'yes' answer" do
        expect(klass.adapters[0]).to receive(:enabled?).with(flag_name).and_return true
        expect(klass.adapters[1]).not_to receive(:enabled?)
        expect(klass.enabled?(flag_name)).to eq(true)
      end
      it "returns nil if none of them give a yes/no answer" do
        expect(klass.adapters[0]).to receive(:enabled?).with(flag_name).and_return nil
        expect(klass.adapters[1]).to receive(:enabled?).and_return nil
        expect(klass.enabled?(flag_name)).to eq(nil)
      end
      it "stops iterating if it gets a 'no' answer" do
        expect(klass.adapters[0]).to receive(:enabled?).with(flag_name).and_return false
        expect(klass.adapters[1]).not_to receive(:enabled?)
        expect(klass.enabled?(flag_name)).to eq(false)
      end
    end
    context "when given a flag name and user" do
      let(:pseudo_user) { OpenStruct.new(flipper_id: 1) }
      it "passes along the user argument to the individual adapters" do
        expect(klass.adapters[0]).to receive(:enabled?).with(flag_name, pseudo_user).and_return true
        expect(klass.adapters[1]).not_to receive(:enabled?)
        expect(klass.enabled?(flag_name, pseudo_user)).to eq(true)
      end
    end
    context "using factory and instance-level api" do
      let(:pseudo_user) { OpenStruct.new(flipper_id: "1") }
      it "forwards query to flipper" do
        expect(klass.adapters[0]).to receive(:enabled?).with(flag_name, pseudo_user).and_return true
        expect(klass.adapters[1]).not_to receive(:enabled?)
        expect(klass[flag_name].enabled?(pseudo_user)).to eq(true)
      end
    end
  end


end
