class ThisFeature
  class Configuration
    attr_writer :adapters, :default_adapter, :test_adapter

    def init
      validate_adapters!
    end

    def validate_adapters!
      raise(NoAdaptersError.new) unless adapters.any?

      adapters.each do |adapter|
        raise BadAdapterError.new(adapter) unless adapter.class < Adapters::Base
      end
    end

    def adapters
      @adapters ||= []
    end

    def default_adapter
      @default_adapter ||= adapters.first
    end

    def test_adapter
      @test_adapter ||= Adapters::Memory.new
    end
  end
end
