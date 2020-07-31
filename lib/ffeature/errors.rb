class FFeature

  class Error < StandardError; end

  class UnimplementedError < Error
    def initialize(klass, fn_name)
      super("class #{klass.name} doesnt implement method .#{fn_name}")
    end
  end

  class BadAdapterError < Error
    def initialize(adapter)
      super("adapter #{adapter.name} doesn't inherit from FFeature::Adapters::Base")
    end
  end

  class NoWriteAdapter < Error
    def initialize
      super("Use the `FFeature.write_adapter=` setter before calling #enable or #disable")
    end
  end

end
