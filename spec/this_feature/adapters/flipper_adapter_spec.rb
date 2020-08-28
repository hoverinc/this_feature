
RSpec.describe ThisFeature::Adapters::Flipper do
  let(:flag_name) { 'a_flag' }

  let(:context) { nil }
  let(:data) { {} }

  let(:pseudo_user) { OpenStruct.new(flipper_id: "User:1") }
  let(:pseudo_user2) { OpenStruct.new(flipper_id: "User:2") }
  let(:pseudo_org) { OpenStruct.new(flipper_id: "Org:1") }
  let(:pseudo_org2) { OpenStruct.new(flipper_id: "Org:2") }

  # before(:each) { described_class.setup }

  # describe ".setup" do
  #   it "doesnt raise an error" do
  #     described_class.setup
  #   end
  # end

  let(:adapter) { described_class.new }

  describe ".on?" do
    subject(:on?) { adapter.on?(flag_name, context: context, data: data) }

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

  describe ".off?" do
    subject(:off?) { adapter.off?(flag_name, context: context, data: data) }

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

  describe '.present?' do
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

  describe ".control?" do
    subject(:control?) { adapter.control?(flag_name) }

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

  # describe '.on!' do
  #   subject(:on!) { adapter.on!(flag_name) }

  #   it 'turns on the flag' do
  #     subject
  #     expect(Flipper[flag_name].enabled?).to eq(true)
  #     expect(adapter.on?(flag_name)).to eq(true)
  #   end

  #   context 'with a user passed as the context' do
  #     subject(:on!) { adapter.on!(flag_name, context: pseudo_user) }

  #     it 'turns on the flag for the specific user' do
  #       subject

  #       expect(Flipper[flag_name].enabled?(pseudo_user)).to be(true)
  #       expect(adapter.present?(flag_name)).to be(true)
  #       expect(adapter.on?(flag_name)).to be(false)
  #       expect(adapter.on?(flag_name, context: pseudo_user)).to be(true)
  #       expect(adapter.on?(flag_name, context: pseudo_user2)).to be(false)
  #     end
  #   end

  #   context 'with an org passed as the context' do
  #     subject(:on!) { adapter.on!(flag_name, context: pseudo_org) }

  #     it 'turns on the flag for the specific org' do
  #       subject

  #       expect(Flipper[flag_name].enabled?(pseudo_org)).to be(true)
  #       expect(adapter.present?(flag_name)).to be(true)
  #       expect(adapter.on?(flag_name)).to be(false)
  #       expect(adapter.on?(flag_name, context: pseudo_org)).to be(true)
  #       expect(adapter.on?(flag_name, context: pseudo_org2)).to be(false)
  #     end
  #   end
  # end

  # describe '.off!' do
  #   subject(:off!) { adapter.off!(flag_name) }

  #   it 'turns off the flag' do
  #     subject
  #     expect(Flipper[flag_name].enabled?).to eq(false)
  #     expect(adapter.off?(flag_name)).to eq(true)
  #   end

  #   context 'with a user passed as the context' do
  #     subject(:off!) { adapter.off!(flag_name, context: pseudo_user) }

  #     it 'turns off the flag for the specific user' do
  #       subject

  #       expect(Flipper[flag_name].enabled?(pseudo_user)).to be(false)
  #       expect(adapter.present?(flag_name)).to be(true)
  #       expect(adapter.off?(flag_name)).to be(true)
  #       expect(adapter.off?(flag_name, context: pseudo_user)).to be(true)
  #       expect(adapter.off?(flag_name, context: pseudo_user2)).to be(true)
  #     end
  #   end

  #   context 'with an org passed as the context' do
  #     subject(:off!) { adapter.off!(flag_name, context: pseudo_org) }

  #     it 'turns off the flag for the specific org' do
  #       subject

  #       expect(Flipper[flag_name].enabled?(pseudo_org)).to be(false)
  #       expect(adapter.present?(flag_name)).to be(true)
  #       expect(adapter.off?(flag_name)).to be(true)
  #       expect(adapter.off?(flag_name, context: pseudo_org)).to be(true)
  #       expect(adapter.off?(flag_name, context: pseudo_org2)).to be(true)
  #     end
  #   end
  # end
end
