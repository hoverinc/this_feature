RSpec.describe ThisFeature::Adapters::SplitIo do
  let(:flag_name) { 'a_flag' }

  let(:context) { nil }
  let(:data) { {} }

  let(:org_id) { 1 }
  let(:another_org_id) { 5 }

  let(:split_file_path) { File.expand_path(File.join('spec', 'support', 'files', 'splits.yaml')) }

  let(:split_client) { SplitIoClient::SplitFactoryBuilder.build('localhost', split_file: split_file_path).client }

  let(:adapter) { described_class.new(client: split_client) }
  let(:flag) { ThisFeature.flag(flag_name, context: context, data: data) }

  before(:each) do
    ThisFeature.configure do |config|
      config.adapters = [adapter]
    end
  end

  context 'when turned on globally' do
    let(:flag_name) { :on_feature }

    it 'is on for everyone' do
      expect(ThisFeature.flag(flag_name).on?).to be true
      expect(ThisFeature.flag(flag_name).off?).to be false
      expect(ThisFeature.flag(flag_name).control?).to be false

      expect(ThisFeature.flag(flag_name, context: org_id).on?).to be true
      expect(ThisFeature.flag(flag_name, context: org_id).off?).to be false
      expect(ThisFeature.flag(flag_name, context: org_id).control?).to be false

      expect(ThisFeature.flag(flag_name, context: another_org_id).on?).to be true
      expect(ThisFeature.flag(flag_name, context: another_org_id).off?).to be false
      expect(ThisFeature.flag(flag_name, context: another_org_id).control?).to be false

      expect(ThisFeature.flag(flag_name, context: org_id, data: { a: :b }).on?).to be true
      expect(ThisFeature.flag(flag_name, context: org_id, data: { a: :b }).off?).to be false
      expect(ThisFeature.flag(flag_name, context: org_id, data: { a: :b }).control?).to be false
    end
  end

  context 'when turned on for specific keys' do
    let(:flag_name) { :partially_on_feature }

    it 'is on for specific orgs' do
      expect(ThisFeature.flag(flag_name).on?).to be false
      expect(ThisFeature.flag(flag_name).off?).to be false
      expect(ThisFeature.flag(flag_name).control?).to be true

      expect(ThisFeature.flag(flag_name, context: org_id).on?).to be true
      expect(ThisFeature.flag(flag_name, context: org_id).off?).to be false
      expect(ThisFeature.flag(flag_name, context: org_id).control?).to be false

      expect(ThisFeature.flag(flag_name, context: another_org_id).on?).to be false
      expect(ThisFeature.flag(flag_name, context: another_org_id).off?).to be false
      expect(ThisFeature.flag(flag_name, context: another_org_id).control?).to be true

      expect(ThisFeature.flag(flag_name, context: org_id, data: { a: :b }).on?).to be true
      expect(ThisFeature.flag(flag_name, context: org_id, data: { a: :b }).off?).to be false
      expect(ThisFeature.flag(flag_name, context: org_id, data: { a: :b }).control?).to be false
    end
  end

  context 'when turned off globally' do
    let(:flag_name) { :off_feature }

    it 'is off for everyone' do
      expect(ThisFeature.flag(flag_name).on?).to be false
      expect(ThisFeature.flag(flag_name).off?).to be true
      expect(ThisFeature.flag(flag_name).control?).to be false

      expect(ThisFeature.flag(flag_name, context: org_id).on?).to be false
      expect(ThisFeature.flag(flag_name, context: org_id).off?).to be true
      expect(ThisFeature.flag(flag_name, context: org_id).control?).to be false

      expect(ThisFeature.flag(flag_name, context: another_org_id).on?).to be false
      expect(ThisFeature.flag(flag_name, context: another_org_id).off?).to be true
      expect(ThisFeature.flag(flag_name, context: another_org_id).control?).to be false

      expect(ThisFeature.flag(flag_name, context: org_id, data: { a: :b }).on?).to be false
      expect(ThisFeature.flag(flag_name, context: org_id, data: { a: :b }).off?).to be true
      expect(ThisFeature.flag(flag_name, context: org_id, data: { a: :b }).control?).to be false
    end
  end
end
