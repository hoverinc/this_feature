klass = FeatureX::Adapters::FlipperAdapter

RSpec.describe klass do

  describe ".setup" do
    it "doesnt raise an error" do
      klass.setup
    end
  end

  describe ".enabled?" do
    let(:sample_flag) { "some flag" }
    let(:pseudo_user) { OpenStruct.new(flipper_id: "User:1") }
    let(:pseudo_user2) { OpenStruct.new(flipper_id: "User:2") }
    let(:pseudo_org) { OpenStruct.new(flipper_id: "Org:1") }
    let(:pseudo_org2) { OpenStruct.new(flipper_id: "Org:2") }

    before(:each) { klass.setup }

    context "looking up a flag that doesnt exist" do
      it "returns nil" do
        skip
        expect(FlipperFeature.pluck(:key)).to eq [sample_flag]
        expect(FlipperGate.count).to eq 0
        expect(klass.enabled?(sample_flag)).to be_nil
      end
    end

    context "looking up a flag that is set to true" do
      it "returns true" do
        Flipper[sample_flag].enable
        expect(FlipperFeature.pluck(:key)).to eq [sample_flag]
        expect(FlipperGate.pluck(:feature_key, :key, :value)).to(
          eq [[sample_flag, "boolean", "true"]]
        )
        expect(klass.enabled?(sample_flag)).to be true
      end
    end

    context "looking up a flag that is set to false" do
      it "returns false" do
        Flipper[sample_flag].disable
        expect(FlipperFeature.pluck(:key)).to eq [sample_flag]
        expect(FlipperGate.count).to eq 0
        expect(klass.enabled?(sample_flag)).to be false
      end
    end

    context "when given a flag name and a user" do
      it "qualifies the search" do
        Flipper[sample_flag].enable(pseudo_user)
        expect(FlipperFeature.pluck(:key)).to eq [sample_flag]
        expect(FlipperGate.pluck(:feature_key, :key, :value)).to(
          eq [[sample_flag, "actors", pseudo_user.flipper_id]]
        )
        expect(klass.enabled?(sample_flag, context: pseudo_user)).to be true
        expect(klass.enabled?(sample_flag, context: pseudo_user2)).to be false
        expect(klass.enabled?(sample_flag)).to be false
      end
    end

    context "when given a flag name and an org" do
      it "qualifies the search" do
        Flipper[sample_flag].enable(pseudo_org)
        expect(FlipperFeature.pluck(:key)).to eq [sample_flag]
        expect(FlipperGate.pluck(:feature_key, :key, :value)).to(
          eq [[sample_flag, "actors", pseudo_org.flipper_id]]
        )
        expect(klass.enabled?(sample_flag, context: pseudo_org)).to be true
        expect(klass.enabled?(sample_flag, context: pseudo_org2)).to be false
        expect(klass.enabled?(sample_flag, context: pseudo_user)).to be false
        expect(klass.enabled?(sample_flag)).to be false
      end
    end
  end

end