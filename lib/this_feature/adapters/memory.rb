class ThisFeature
  module Adapters
    class Memory < Base

      def self.setup(context_id_method: :id)
        @context_id_method = context_id_method
      end

      def self.clear
        storage.clear
      end

      def self.present?(flag_name)
        !storage[flag_name].nil?
      end

      def self.on?(flag_name, context: nil, data: {})
        # binding.pry
        return unless present?(flag_name)

        flag_data = storage[flag_name]

        return true if flag_data[:global]
        return false if context.nil?

        flag_data[:contexts] ||= {}

        !!flag_data[:contexts][context.send(@context_id_method)]
      end

      def self.off?(flag_name, context: nil, data: {})
        on_result = on?(flag_name, context: context)

        return if on_result.nil?

        !on_result
      end

      def self.on!(flag_name, context: nil, data: {})
        storage[flag_name] ||= {}

        return storage[flag_name][:global] = true if context.nil?

        storage[flag_name][:contexts] ||= {}
        storage[flag_name][:contexts][context.send(@context_id_method)] = true
      end

      def self.off!(flag_name, context: nil, data: {})
        storage[flag_name] ||= {}

        return storage[flag_name][:global] = false if context.nil?

        storage[flag_name][:contexts] ||= {}
        storage[flag_name][:contexts][context.send(@context_id_method)] = false
      end

      def self.storage
        @storage ||= {}
      end
    end
  end
end
