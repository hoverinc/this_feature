
class ThisFeature
  class Configuration
    attr_writer :adapters, :default_adapter

    def init
      validate_adapters!

      adapters.each(&:setup)
    end

    def validate_adapters!
      adapters.each do |adapter|
        raise BadAdapterError.new(adapter) unless adapter < Adapters::Base
      end
    end

    def adapters
      @adapters ||= []
    end

    def default_adapter
      @default_adapter ||= adapters.first
    end
  end
end
