
##
# @param [String] string
# @return [Boolean]
def present?(string)
  !string.nil? && !string.empty? && string.strip.length > 0
end

module FuriganaRuby
  class Parser
    attr_reader :reading, :expression, :hiragana, :reading_html

    ##
    # @param [String] text
    def initialize(text)
      @segments = FuriganaParser.new(text).segments
    end

    def reading
      @_reading ||= @segments.map(&:reading).join("")
    end

    def expression
      @_expression ||= @segments.map(&:expression).join("")
    end

    def hiragana
      @_hiragana ||= @segments.map(&:hiragana).join("")
    end

    def reading_html
      @_reading_html ||= @segments.map(&:reading_html).join("")
    end

    class FuriganaParser
      attr_reader :segments

      ##
      # @param [String] reading
      def initialize(reading)
        @segments = []
        @current_base = ""
        @current_furigana = ""
        @parsing_base_section = true
        @characters = present?(reading) && reading.length ? reading.split("") : []

        process
      end
      
      

      def process
        while @characters.length > 0
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

      def next_segment
        if @current_base.length > 0
          @segments << get_segment(@current_base, @current_furigana)
        end

        @current_base = ""
        @current_furigana = ""
        @parsing_base_section = true
      end

      ##
      # @param [String] base_text
      # @param [String] furigana
      def get_segment(base_text, furigana)
        # puts("get_segment/furigana: #{furigana}")
        unless present?(furigana)
          return UndecoratedSegment.new(base_text)
        end

        FuriganaSegment.new(base_text, furigana)
      end

      ##
      # @param [String] current
      # @param [Array<String>] character_list
      # @return [Boolean]
      def last_character_in_block?(current, character_list)
        character_list.length == 0 ||
          (
            kanji?(current) != kanji?(character_list[0]) &&
              character_list[0] != "["
          )
      end

      ##
      # @return [Boolean]
      def kanji?(character)
        char = character[0, 1]
        present?(character) && char.ord >= 0x4e00 && char.ord <= 0x9faf
      end
    end

    class FuriganaSegment
      attr_reader :expression, :hiragana, :reading, :reading_html

      ##
      # @param [String] base_text
      # @param [String] furigana
      def initialize(base_text, furigana)
        @expression = base_text
        @hiragana = furigana.strip
        @reading = base_text + "[" + furigana + "]"
        @reading_html = "<ruby><rb>" + base_text + "</rb><rt>" + furigana + "</rt></ruby>"
      end
    end

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