module FeatureX
  module Adapters
    module Base

      def self.setup
        raise UnimplementedError
      end

      def self.enabled?(flag_name)
        raise UnimplementedError
      end

    end
  end
end