# frozen_string_literal: true

require_relative "utils"

module FuriganaRuby
  ##
  # Performs parsing
  class Parser
    ##
    # @param [String] text
    def initialize(text)
      @segments = FuriganaParser.new(text).segments
    end

    def reading
      @reading ||= @segments.map(&:reading).join("")
    end

    def expression
      @expression ||= @segments.map(&:expression).join("")
    end

    def hiragana
      @hiragana ||= @segments.map(&:hiragana).join("")
    end

    def reading_html
      @reading_html ||= @segments.map(&:reading_html).join("")
    end

    ##
    # Performs the parsing
    class FuriganaParser
      attr_reader :segments

      ##
      # @param [String] reading
      def initialize(reading)
        @segments = []
        @current_base = ""
        @current_furigana = ""
        @parsing_base_section = true
        @characters = Utils.present?(reading) && reading.length ? reading.split("") : []

        process
      end

      # rubocop:disable Metrics/MethodLength
      def process
        while @characters.length.positive?
          current = @characters.shift

          if current == "["
            @parsing_base_section = false
          elsif current == "]"
            next_segment
          elsif last_character_in_block?(current, @characters) && @parsing_base_section
            @current_base += current
            next_segment
          elsif !@parsing_base_section
            @current_furigana += current
          else
            @current_base += current
          end
        end

        next_segment
      end
      # rubocop:enable Metrics/MethodLength

      def next_segment
        @segments << get_segment(@current_base, @current_furigana) if @current_base.length.positive?

        @current_base = ""
        @current_furigana = ""
        @parsing_base_section = true
      end

      ##
      # @param [String] base_text
      # @param [String] furigana
      def get_segment(base_text, furigana)
        return UndecoratedSegment.new(base_text) unless Utils.present?(furigana)

        FuriganaSegment.new(base_text, furigana)
      end

      ##
      # @param [String] current
      # @param [Array<String>] character_list
      # @return [Boolean]
      def last_character_in_block?(current, character_list)
        character_list.length.zero? ||
          (
            kanji?(current) != kanji?(character_list[0]) &&
              character_list[0] != "["
          )
      end

      ##
      # @return [Boolean]
      def kanji?(character)
        char = character[0, 1]
        Utils.present?(character) && char.ord >= 0x4e00 && char.ord <= 0x9faf
      end
    end

    ##
    # Segment with ruby markup
    class FuriganaSegment
      attr_reader :expression, :hiragana, :reading, :reading_html

      ##
      # @param [String] base_text
      # @param [String] furigana
      def initialize(base_text, furigana)
        @expression = base_text
        @hiragana = furigana.strip
        @reading = "#{base_text}[#{furigana}]"
        @reading_html = "<ruby><rb>#{base_text}</rb><rt>#{furigana}</rt></ruby>"
      end
    end

    ##
    # Segment not needing ruby markup
    class UndecoratedSegment
      attr_reader :expression, :hiragana, :reading, :reading_html

      ##
      # @param [String] base_text
      def initialize(base_text)
        # puts("Undecorated: #{base_text}")
        @expression = base_text
        @hiragana = base_text
        @reading = base_text
        @reading_html = base_text
      end
    end
  end
end
