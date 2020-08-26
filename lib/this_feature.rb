require 'this_feature/version'
require 'this_feature/adapters'
require 'this_feature/errors'
require 'this_feature/configuration'
require 'this_feature/flag'

class ThisFeature
  def self.flag(flag_name, context: nil, data: {})
    adapter = adapter_for(flag_name, context: nil, data: {})

    Flag.new(flag_name, adapter: adapter, context: context, data: data)
  end

  def self.adapter_for(flag_name, context: nil, data: {})
    matching_adapter = adapters.find do |adapter|
      adapter.present?(flag_name, context: context, data: data)
    end

    matching_adapter || configuration.default_adapter
  end

  # Configuration

  def self.configuration
    @configuration ||= Configuration.new
  end

  def self.configure
    yield(configuration)

    configuration.init
  end

  def self.adapters
    configuration.adapters
  end

end
