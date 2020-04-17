require "flipper"
require "flipper/adapters/active_record"

module FeatureX
  module Adapters
    module Flipper

      # Alias the toplevel constant from the gem
      FLIPPER = ::Flipper

      def self.setup
        FLIPPER.configure do |config|
          config.default do
            adapter = FLIPPER::Adapters::ActiveRecord.new
            FLIPPER.new(adapter)
          end
        end
      end

      def self.enabled?(flag_name)
        FLIPPER[flag_name].enabled?
      end

    end
  end
end