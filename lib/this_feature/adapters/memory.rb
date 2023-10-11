class ThisFeature
  module Adapters
    class Memory < Base
      def initialize(context_key_method: nil)
        @context_key_method = context_key_method
      end

      def clear
        storage.clear
      end

      def present?(flag_name)
        !storage[flag_name].nil?
      end

      def on?(flag_name, context: nil, data: {}, record: nil)
        return false unless present?(flag_name)

        flag_data = storage[flag_name]

        context_registered = flag_data[:contexts]&.key?(context_key(context))

        return !!flag_data[:global] if !context || (context && !context_registered)

        flag_data[:contexts] ||= {}
        !!flag_data[:contexts][context_key(context)]
      end

      def off?(flag_name, context: nil, data: {}, record: nil)
        !on?(flag_name, context: context, data: data)
      end

      def control?(flag_name, **kwargs)
        !present?(flag_name)
      end

      # def treatment_config(flag_name, context: nil, data: {}, record: nil)

      def treatment_value(flag_name, context: nil, data: {}, record: nil)
        return 'control' if !present?(flag_name) || context.nil?

        flag_data = storage[flag_name][:treatment_contexts]
        context_registered = flag_data&.key?(context_key(context))

        return 'control' if !flag_data || !context_registered

        flag_data ||= {}
        flag_data[context_key(context)]
      end

      def enable_treatment!(flag_name, treatment: nil, context: nil)
        return false if treatment.nil? || flag_name.nil? || context.nil?

        storage[flag_name] ||= {}
        storage[flag_name][:treatment_contexts] ||= {}
        storage[flag_name][:treatment_contexts][context_key(context)] = treatment
      end

      def on!(flag_name, context: nil, data: {})
        storage[flag_name] ||= {}

        return storage[flag_name][:global] = true if context.nil?

        storage[flag_name][:contexts] ||= {}
        storage[flag_name][:contexts][context_key(context)] = true
      end

      def off!(flag_name, context: nil, data: {})
        storage[flag_name] ||= {}

        return storage[flag_name][:global] = false if context.nil?

        storage[flag_name][:contexts] ||= {}
        storage[flag_name][:contexts][context_key(context)] = false
      end

      def storage
        @storage ||= {}
      end

      private

      attr_reader :context_key_method

      def context_key(context)
        return nil unless context
        return context if context_key_method.nil?

        context.send(context_key_method)
      end
    end
  end
end
