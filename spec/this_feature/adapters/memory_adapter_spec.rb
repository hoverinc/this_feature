RSpec.describe ThisFeature::Adapters::Memory do
  let(:flag_name) { 'a_flag' }

  let(:context) { nil }
  let(:data) { {} }

  let(:pseudo_user) { OpenStruct.new(id: 'User:1') }
  let(:pseudo_user2) { OpenStruct.new(id: 'User:2') }

  let(:adapter) { described_class.new }
  let(:flag) { ThisFeature.flag(flag_name, context: context, data: data) }

  before(:each) do
    adapter.clear

    ThisFeature.configure do |config|
      config.adapters = [adapter]
    end
  end

  describe 'on?' do
    subject(:on?) { flag.on? }

    context "looking up a flag that doesn't exist" do
      it { is_expected.to be(false) }
    end

    context 'looking up a flag that is set to on' do
      before { adapter.on!(flag_name) }

      it { is_expected.to be(true) }

      it 'is on for a specific user' do
        expect(ThisFeature.flag(flag_name, context: pseudo_user).on?).to be true
        expect(ThisFeature.flag(flag_name, context: pseudo_user).off?).to be false
      end
    end

    context 'looking up a flag that is set to off' do
      before { adapter.off!(flag_name) }

      it { is_expected.to be(false) }

      it 'is off for a specific user' do
        expect(ThisFeature.flag(flag_name, context: pseudo_user).off?).to be true
        expect(ThisFeature.flag(flag_name, context: pseudo_user).on?).to be false
      end
    end

    context 'when given a flag name and a user' do
      it 'qualifies the search' do
        adapter.on!(flag_name, context: pseudo_user)
        expect(ThisFeature.flag(flag_name).on?).to be false
        expect(ThisFeature.flag(flag_name, context: pseudo_user2).on?).to be false
        expect(ThisFeature.flag(flag_name, context: pseudo_user).on?).to be true
      end
    end

    context 'when specifying context_key_method' do
      let(:pseudo_user) { OpenStruct.new(name: 'user_1', id: 'User:1') }
      let(:pseudo_user2) { OpenStruct.new(name: 'user_2', id: 'User:1') }
      let(:pseudo_user3) { OpenStruct.new(name: 'user_1', id: 'User:3') }
      let(:context_key_method) { :id }

      let(:adapter) { described_class.new(context_key_method: context_key_method) }

      it 'uses the context key method to look up the flag status' do
        adapter.on!(flag_name, context: pseudo_user)
        expect(ThisFeature.flag(flag_name).on?).to be false
        expect(ThisFeature.flag(flag_name, context: pseudo_user).on?).to be true
        expect(ThisFeature.flag(flag_name, context: pseudo_user2).on?).to be true
        expect(ThisFeature.flag(flag_name, context: pseudo_user3).on?).to be false
      end
    end
  end

  describe 'off?' do
    subject(:off?) { flag.off? }

    context "looking up a flag that doesn't exist" do
      it "returns nil" do
        expect(subject).to be(true)
      end
    end

    context "looking up a flag that is set to off" do
      before { adapter.off!(flag_name) }

      it { is_expected.to be(true) }
    end

    context 'looking up a flag that is set to on' do
      before { adapter.on!(flag_name) }

      it { is_expected.to be(false) }
    end

    context 'when given a flag name and a user' do
      it 'qualifies the search' do
        adapter.on!(flag_name, context: pseudo_user)
        expect(ThisFeature.flag(flag_name).off?).to be true
        expect(ThisFeature.flag(flag_name, context: pseudo_user2).off?).to be true
        expect(ThisFeature.flag(flag_name, context: pseudo_user).off?).to be false
      end
    end

    context 'when specifying context_key_method' do
      let(:pseudo_user) { OpenStruct.new(name: 'user_1', id: 'User:1') }
      let(:pseudo_user2) { OpenStruct.new(name: 'user_2', id: 'User:1') }
      let(:pseudo_user3) { OpenStruct.new(name: 'user_1', id: 'User:3') }
      let(:context_key_method) { :id }

      let(:adapter) { described_class.new(context_key_method: context_key_method) }

      context 'when the flag is on for a user' do
        it 'uses the context key method to look up the flag status' do
          adapter.on!(flag_name, context: pseudo_user)
          expect(ThisFeature.flag(flag_name).off?).to be true
          expect(ThisFeature.flag(flag_name, context: pseudo_user).off?).to be false
          expect(ThisFeature.flag(flag_name, context: pseudo_user2).off?).to be false
          expect(ThisFeature.flag(flag_name, context: pseudo_user3).off?).to be true
        end
      end

      context 'when the flag is off for a user' do
        it 'uses the context key method to look up the flag status' do
          adapter.off!(flag_name, context: pseudo_user)
          expect(ThisFeature.flag(flag_name).off?).to be true
          expect(ThisFeature.flag(flag_name, context: pseudo_user).off?).to be true
          expect(ThisFeature.flag(flag_name, context: pseudo_user2).off?).to be true
          expect(ThisFeature.flag(flag_name, context: pseudo_user3).off?).to be true
        end
      end

    end
  end

  describe 'control?' do
    subject(:control?) { flag.control? }

    context "when the flag doesn't exist" do
      it 'returns true' do
        expect(control?).to be true
      end
    end

    context "when the flag exists" do
      before do
        adapter.on!(flag_name, context: pseudo_user)
      end

      it 'returns false' do
        expect(control?).to be false
      end
    end
  end

  describe '#present?' do
    subject(:present?) { adapter.present?(flag_name) }

    it { is_expected.to be(false) }

    context 'when flag is enabled globally' do
      before { adapter.on!(flag_name) }

      it { is_expected.to be(true) }
    end

    context 'when flag is enabled for a specific context' do
      before { adapter.on!(flag_name, context: pseudo_user) }

      it { is_expected.to be(true) }
    end

    context 'when flag is disabled globally' do
      before { adapter.off!(flag_name) }

      it { is_expected.to be(true) }
    end

    context 'when flag is disabled for a specific context' do
      before { adapter.off!(flag_name, context: pseudo_user) }

      it { is_expected.to be(true) }
    end
  end

  describe '.on!' do
    subject(:on!) { adapter.on!(flag_name) }

    it 'turns on the flag' do
      subject
      expect(adapter.on?(flag_name)).to eq(true)
    end

    context 'with a user passed as the context' do
      subject(:on!) { adapter.on!(flag_name, context: pseudo_user) }

      it 'turns on the flag for the specific user' do
        subject

        expect(adapter.present?(flag_name)).to be(true)
        expect(adapter.on?(flag_name)).to be(false)
        expect(adapter.on?(flag_name, context: pseudo_user)).to be(true)
        expect(adapter.on?(flag_name, context: pseudo_user2)).to be(false)
      end
    end
  end

  describe '.off!' do
    subject(:off!) { adapter.off!(flag_name) }

    it 'turns off the flag' do
      subject
      expect(adapter.off?(flag_name)).to eq(true)
    end

    context 'with a user passed as the context' do
      subject(:off!) { adapter.off!(flag_name, context: pseudo_user) }

      it 'turns off the flag for the specific user' do
        subject

        expect(adapter.present?(flag_name)).to be(true)
        expect(adapter.off?(flag_name)).to be(true)
        expect(adapter.off?(flag_name, context: pseudo_user)).to be(true)
        expect(adapter.off?(flag_name, context: pseudo_user2)).to be(true)
      end
    end
  end
end
