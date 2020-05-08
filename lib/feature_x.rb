require "feature_x/version"
require 'feature_x/adapters'
require 'feature_x/errors'

class FeatureX
  def self.adapters
    @adapters || []
  end

  def self.set_adapters(adapters_list)
    adapters_list.each do |adapter|
      unless adapter < Adapters::BaseAdapter
        raise BadAdapterError.new(adapter)
      end
    end

    adapters_list.each(&:setup)
    @adapters = adapters_list
  end

  def self.enabled?(flag_name, context: nil)
    # Queries each of the adapters in order,
    # returning the first non-nil result.
    # Returns nil if none were found.
    result = nil
    adapters.each do |adapter|
      val = adapter.enabled?(flag_name, context: context)
      unless val.nil?
        result = val
        break
      end
    end
    result
  end

end
