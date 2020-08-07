class FFeature
  module Adapters
    class Base

      def self.setup
        raise UnimplementedError.new(self, __method__)
      end

      def self.on?(flag_name, context: nil, data: {})
        raise UnimplementedError.new(self, __method__)
      end

      def self.off?(flag_name, context: nil, data: {})
        raise UnimplementedError.new(self, __method__)
      end

      def self.control?(flag_name, context: nil, data: {})
        raise UnimplementedError.new(self, __method__)
      end

      def self.on!(flag_name, context: nil, data: {})
        raise UnimplementedError.new(self, __method__)
      end

      def self.off!(flag_name, context: nil, data: {})
        raise UnimplementedError.new(self, __method__)
      end

    end
  end
end
