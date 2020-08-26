RSpec.describe ThisFeature::Adapters::Memory do
  let(:flag_name) { 'a_flag' }

  let(:context) { nil }
  let(:data) { {} }

  let(:pseudo_user) { OpenStruct.new(id: "User:1") }
  let(:pseudo_user2) { OpenStruct.new(id: "User:2") }

  before(:each) do
    described_class.clear
  end

  describe ".setup" do
    it "doesnt raise an error" do
      described_class.setup
    end
  end

  describe ".on?" do
    subject(:on?) { described_class.on?(flag_name, context: context, data: data) }

    context "looking up a flag that doesnt exist" do
      it { is_expected.to be_nil }
    end

    context "looking up a flag that is set to on" do
      before { described_class.on!(flag_name) }

      it { is_expected.to be(true) }
    end

    context "looking up a flag that is set to off" do
      before { described_class.off!(flag_name) }

      it { is_expected.to be(false) }
    end

    context "when given a flag name and a user" do
      it "qualifies the search" do
        described_class.on!(flag_name, context: pseudo_user)
        expect(described_class.on?(flag_name)).to be false
        expect(described_class.on?(flag_name, context: pseudo_user2)).to be false
        expect(described_class.on?(flag_name, context: pseudo_user)).to be true
      end
    end
  end

  describe ".off?" do
    subject(:off?) { described_class.off?(flag_name, context: context, data: data) }

    context "looking up a flag that doesnt exist" do
      it "returns nil" do
        expect(subject).to be_nil
      end
    end

    context "looking up a flag that is set to off" do
      before { described_class.off!(flag_name) }

      it { is_expected.to be(true) }
    end

    context "looking up a flag that is set to on" do
      before { described_class.on!(flag_name) }

      it { is_expected.to be(false) }
    end

    context "when given a flag name and a user" do
      it "qualifies the search" do
        described_class.on!(flag_name, context: pseudo_user)
        expect(described_class.off?(flag_name)).to be true
        expect(described_class.off?(flag_name, context: pseudo_user2)).to be true
        expect(described_class.off?(flag_name, context: pseudo_user)).to be false
      end
    end
  end

  describe '.present?' do
    subject(:present?) { described_class.present?(flag_name) }

    it { is_expected.to be(false) }

    context 'when flag is enabled' do
      before { described_class.on!(flag_name) }

      it { is_expected.to be(true) }
    end

    context 'when flag is disabled' do
      before { described_class.off!(flag_name) }

      it { is_expected.to be(true) }
    end
  end

  describe '.on!' do
    subject(:on!) { described_class.on!(flag_name) }

    it 'turns on the flag' do
      subject
      expect(described_class.on?(flag_name)).to eq(true)
    end

    context 'with a user passed as the context' do
      subject(:on!) { described_class.on!(flag_name, context: pseudo_user) }

      it 'turns on the flag for the specific user' do
        subject

        expect(described_class.present?(flag_name)).to be(true)
        expect(described_class.on?(flag_name)).to be(false)
        expect(described_class.on?(flag_name, context: pseudo_user)).to be(true)
        expect(described_class.on?(flag_name, context: pseudo_user2)).to be(false)
      end
    end
  end

  describe '.off!' do
    subject(:off!) { described_class.off!(flag_name) }

    it 'turns off the flag' do
      subject
      expect(described_class.off?(flag_name)).to eq(true)
    end

    context 'with a user passed as the context' do
      subject(:off!) { described_class.off!(flag_name, context: pseudo_user) }

      it 'turns off the flag for the specific user' do
        subject

        expect(described_class.present?(flag_name)).to be(true)
        expect(described_class.off?(flag_name)).to be(true)
        expect(described_class.off?(flag_name, context: pseudo_user)).to be(true)
        expect(described_class.off?(flag_name, context: pseudo_user2)).to be(true)
      end
    end
  end
end
