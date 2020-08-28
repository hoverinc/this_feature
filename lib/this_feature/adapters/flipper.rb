require "flipper"
require "flipper/adapters/active_record"

class ThisFeature
  module Adapters
    class Flipper < Base
      class << self
        def setup(flipper = nil)
          return @flipper = flipper unless flipper.nil?

          @flipper = ::Flipper

          ::Flipper.configure do |config|
            config.default do
              adapter = ::Flipper::Adapters::ActiveRecord.new
              ::Flipper.new(adapter)
            end
          end
        end

        def present?(flag_name)
          flipper[flag_name].exist?
        end

        def control?(flag_name)
          !present?(flag_name)
        end

        def on?(flag_name, context: nil, data: {})
          return unless present?(flag_name)

          flipper[flag_name].enabled?(*[context].compact)
        end

        def off?(flag_name, context: nil, data: {})
          on_result = on?(flag_name, context: context)

          return if on_result.nil?

          !on_result
        end

        def on!(flag_name, context: nil, data: {})
          flipper[flag_name].enable(*[context].compact)
        end

        def off!(flag_name, context: nil, data: {})
          flipper[flag_name].disable(*[context].compact)
        end

        def flipper
          @flipper
        end
      end
    end
  end
end
