
RSpec.describe ThisFeature::Adapters::Flipper do
  let(:flag_name) { 'a_flag' }

  let(:context) { nil }
  let(:data) { {} }

  let(:pseudo_user) { OpenStruct.new(flipper_id: "User:1") }
  let(:pseudo_user2) { OpenStruct.new(flipper_id: "User:2") }
  let(:pseudo_org) { OpenStruct.new(flipper_id: "Org:1") }
  let(:pseudo_org2) { OpenStruct.new(flipper_id: "Org:2") }

  let(:adapter) { described_class.new }
  let(:flag) { ThisFeature.flag(flag_name, context: context, data: data) }

  before do
    ThisFeature.configure do |config|
      config.adapters = [adapter]
    end
  end

  describe "#initialize" do

    context "when passed a custom client" do
      let(:fake_client) { "my fake client" }
      let(:adapter) { described_class.new(client: fake_client) }

      it "uses that custom client" do
        expect(adapter.client).to eq(fake_client)
      end
    end

    context "when not passed a custom client" do
      let(:adapter) { described_class.new }

      it "uses a default client" do
        expect(adapter.client).to eq(::Flipper)
      end
    end
  end

  describe "#present?" do
    subject(:present?) { adapter.present?(flag_name) }

    it { is_expected.to be(false) }

    context 'when flag is enabled' do
      before { Flipper[flag_name].enable }

      it { is_expected.to be(true) }
    end

    context 'when flag is disabled' do
      before { Flipper[flag_name].disable }

      it { is_expected.to be(true) }
    end
  end

  describe "on?" do
    subject(:on?) { flag.on? }

    context "looking up a flag that doesnt exist" do
      it { is_expected.to be_nil }
    end

    context "looking up a flag that is set to on" do
      before { Flipper[flag_name].enable }

      it { is_expected.to be(true) }
    end

    context "looking up a flag that is set to off" do
      before { Flipper[flag_name].disable }

      it { is_expected.to be(false) }
    end

    context "when given a flag name and a user" do
      it "qualifies the search" do
        Flipper[flag_name].enable(pseudo_user)
        expect(Flipper[flag_name].enabled?(pseudo_user)).to eq true
        expect(adapter.on?(flag_name)).to be false
        expect(adapter.on?(flag_name, context: pseudo_user2)).to be false
        expect(adapter.on?(flag_name, context: pseudo_user)).to be true
      end
    end

    context "when given a flag name and an org" do
      it "qualifies the search" do
        Flipper[flag_name].enable(pseudo_org)
        expect(Flipper[flag_name].enabled?(pseudo_org)).to eq true
        expect(adapter.on?(flag_name)).to be false
        expect(adapter.on?(flag_name, context: pseudo_org2)).to be false
        expect(adapter.on?(flag_name, context: pseudo_org)).to be true
      end
    end
  end

  describe "off?" do
    subject(:off?) { flag.off? }

    context "looking up a flag that doesnt exist" do
      it "returns nil" do
        expect(subject).to be_nil
      end
    end

    context "looking up a flag that is set to off" do
      before { Flipper[flag_name].disable }

      it { is_expected.to be(true) }
    end

    context "looking up a flag that is set to on" do
      before { Flipper[flag_name].enable }

      it { is_expected.to be(false) }
    end

    context "when given a flag name and a user" do
      it "qualifies the search" do
        Flipper[flag_name].enable(pseudo_user)
        expect(Flipper[flag_name].enabled?(pseudo_user)).to eq true
        expect(adapter.off?(flag_name)).to be true
        expect(adapter.off?(flag_name, context: pseudo_user2)).to be true
        expect(adapter.off?(flag_name, context: pseudo_user)).to be false
      end
    end

    context "when given a flag name and an org" do
      it "qualifies the search" do
        Flipper[flag_name].enable(pseudo_org)
        expect(Flipper[flag_name].enabled?(pseudo_org)).to eq true
        expect(adapter.off?(flag_name)).to be true
        expect(adapter.off?(flag_name, context: pseudo_org2)).to be true
        expect(adapter.off?(flag_name, context: pseudo_org)).to be false
      end
    end
  end

  describe "control?" do
    subject(:control?) { flag.control? }

    it { is_expected.to be(true) }

    context 'when flag is enabled' do
      before { Flipper[flag_name].enable }

      it { is_expected.to be(false) }
    end

    context 'when flag is disabled' do
      before { Flipper[flag_name].disable }

      it { is_expected.to be(false) }
    end
  end
end
