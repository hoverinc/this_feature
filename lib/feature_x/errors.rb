module FeatureX

  class Error < StandardError; end

  class UnimplementedError < Error
    def message
      "not implemented"
    end
  end

end