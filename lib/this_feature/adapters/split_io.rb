require 'splitclient-rb'

class ThisFeature
  module Adapters
    class SplitIo < Base
      class << self

        def setup(split_client:)
          @@split_client = split_client
          split_client.block_until_ready
        rescue SplitIoClient::SDKBlockerTimeoutExpiredException
          raise 'Split SDK is not ready. Abort execution.'
        end

        def present?(flag_name)
          !control?(flag_name, context: 'undefined')
        end

        def control?(flag_name, context:, data: {})
          treatment(flag_name, context:, data).eql?('control')
        end

        def on?(flag_name, context:, data: {})
          treatment(flag_name, context:, data).eql?('on')
        end

        def off?(flag_name, context:, data: {})
          treatment(flag_name, context:, data).eql?('off')
        end

        def on!(flag_name, context:, data: {})
        end

        def off!(flag_name, context:, data: {})
        end

        def treatment(flag_name, context:, data: {})
          key = context.respond_to?(:to_s) ? context.to_s : context
          client.get_treatment(key, flag_name, attributes)[:treatment]
        end

        def split_client
          @@split_client
        end
      end
    end
  end
end
