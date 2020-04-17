module FeatureX

  class Error < StandardError; end

  class UnimplementedError < Error
    def initialize(klass, fn_name)
      super("class #{klass.name} doesnt implement method .#{fn_name}")
    end
  end

  class BadAdapterError < Error
    def initialize(adapter)
      super("adapter #{adapter.name} doesn't inherit from FeatureX::Adapters::BaseAdapter")
    end
  end

end