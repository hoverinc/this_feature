require "flipper"
require "flipper/adapters/active_record"

module FeatureX
  module Adapters
    class FlipperAdapter < BaseAdapter

      def self.setup
        Flipper.configure do |config|
          config.default do
            adapter = Flipper::Adapters::ActiveRecord.new
            Flipper.new(adapter)
          end
        end
      end

      def self.enabled?(flag_name, user=nil)
        Flipper[flag_name].enabled?(*[user].compact)
      end

    end
  end
end