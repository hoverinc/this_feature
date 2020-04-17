klass = FeatureX::Adapters::FlipperAdapter

RSpec.describe klass do

  describe ".setup" do
    it "doesnt raise an error" do
      klass.setup
    end
  end

  describe ".enabled?" do
    let(:sample_flag) { "some flag" }
    before(:each) { klass.setup }

    context "when given just a flag name" do

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

    end

    context "when given a flag name and a user" do
      let(:pseudo_user) { OpenStruct.new(flipper_id: "1") }
      let(:pseudo_user2) { OpenStruct.new(flipper_id: "2") }
      it "qualifies the search" do
        Flipper[sample_flag].enable(pseudo_user)
        expect(FlipperFeature.pluck(:key)).to eq [sample_flag]
        expect(FlipperGate.pluck(:feature_key, :key, :value)).to(
          eq [[sample_flag, "actors", pseudo_user.flipper_id]]
        )
        expect(klass.enabled?(sample_flag, pseudo_user)).to be true
        expect(klass.enabled?(sample_flag, pseudo_user2)).to be false
        expect(klass.enabled?(sample_flag)).to be false
      end
    end
  end

end