require "flipper"
require "flipper/adapters/active_record"

class FFeature
  module Adapters
    class Flipper < Base

      def self.setup(flipper = nil)
        return @flipper = flipper unless flipper.nil?

        @flipper = ::Flipper

        ::Flipper.configure do |config|
          config.default do
            adapter = ::Flipper::Adapters::ActiveRecord.new
            ::Flipper.new(adapter)
          end
        end
      end

      def self.present?(flag_name)
        flipper[flag_name].exist?
      end

      def self.on?(flag_name, context: nil, data: {})
        return unless present?(flag_name)

        flipper[flag_name].enabled?(*[context].compact)
      end

      def self.off?(...)
        return if on?(...).nil?

        !on?(...)
      end

      def self.on!(flag_name, context: nil, data: {})
        flipper[flag_name].enable(*[context].compact)
      end

      def self.off!(flag_name, context: nil, data: {})
        flipper[flag_name].disable(*[context].compact)
      end

      def self.flipper
        @flipper
      end
    end
  end
end
