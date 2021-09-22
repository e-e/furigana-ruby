# frozen_string_literal: true

module FuriganaRuby
  ##
  # Util methods
  class Utils
    class << self
      ##
      # @param [String] string
      # @return [Boolean]
      def present?(string)
        !string.nil? && !string.empty? && string.strip.length.positive?
      end
    end
  end
end
