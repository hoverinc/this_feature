require 'ffeature/version'
require 'ffeature/adapters'
require 'ffeature/errors'

class FFeature

  # In order to use #enable and #disable, the write_adapter needs to be specified.
  # It doesn't make sense for us to scan through all the adapters in that case.
  cattr_accessor :write_adapter

  def self.adapters
    @adapters || []
  end

  def self.set_adapters(adapters_list)
    # Validate that the given adapters inherit from BaseAdapter
    adapters_list.each do |adapter|
      unless adapter < Adapters::BaseAdapter
        raise BadAdapterError.new(adapter)
      end
    end

    # Initialize each of the adapters
    adapters_list.each(&:setup)

    @adapters = adapters_list
  end

  def self.enabled?(flag_name, context: nil)
    # Queries each of the adapters in order, returning the first non-nil result.
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

  def self.enable(flag_name, context: nil)
    raise(NoWriteAdapter.new) unless write_adapter
    write_adapter.enable(flag_name, context: context)
  end

  def self.disable(flag_name, context: nil)
    raise(NoWriteAdapter.new) unless write_adapter
    write_adapter.disable(flag_name, context: context)
  end

  # # =======================================================
  # # Factory method for building an instance.
  # # We're mirroring the Flipper API here for easy migration
  # # =======================================================

  def self.[](flag_name)
    new(flag_name)
  end

  attr_accessor :flag_name

  def initialize(flag_name)
    @flag_name = flag_name
  end

  def enabled?(user_or_org=nil)
    self.class.enabled?(flag_name, context: user_or_org)
  end

  def enable(user_or_org=nil)
    self.class.enable(flag_name, context: user_or_org)
  end

  alias enable_actor enable

  def disable(user_or_org=nil)
    self.class.disable(flag_name, context: user_or_org)
  end

  alias disable_actor disable

end
