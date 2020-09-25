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
    return configuration.test_adapter if configuration.test_adapter

    matching_adapter = adapters.find do |adapter|
      adapter.present?(flag_name)
    end

    matching_adapter || configuration.default_adapter
  end

  def self.configuration
    @configuration ||= Configuration.new
  end

  def self.configure
    @configuration = Configuration.new

    yield(configuration)

    configuration.init
  end

  def self.adapters
    configuration.adapters
  end

  def self.test_adapter
    configuration.test_adapter
  end
end
