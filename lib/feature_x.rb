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

  def self.enabled?(flag_name, user_or_org=nil)
    # Queries each of the adapters in order,
    # returning the first non-nil result.
    # Returns nil if none were found.
    result = nil
    adapters.each do |adapter|
      val = adapter.enabled?(flag_name, *[user_or_org].compact)
      unless val.nil?
        result = val
        break
      end
    end
    result
  end

  # =======================================================
  # Factory method for building an instance.
  # We're mirroring the Flipper API here for easy migration
  # =======================================================

  def self.[](flag_name)
    new.tap { |instance| instance.flag_name = flag_name }
  end

  attr_accessor :flag_name

  def enabled?(user_or_org=nil)
    self.class.enabled?(flag_name, user_or_org)
  end

end
