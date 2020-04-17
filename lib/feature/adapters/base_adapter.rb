class Feature
  module Adapters
    class BaseAdapter

      def self.setup
        raise UnimplementedError.new(self, __method__)
      end

      def self.enabled?(flag_name, context: nil)
        raise UnimplementedError.new(self, __method__)
      end

      def self.enable(flag_name, context: nil)
        raise UnimplementedError.new(self, __method__)
      end

      def self.disable(flag_name, context: nil)
        raise UnimplementedError.new(self, __method__)
      end

    end
  end
end