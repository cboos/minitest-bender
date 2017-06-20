module MinitestBender
  module Results
    class Base
      extend Forwardable
      def_delegators :@minitest_result, :passed?, :skipped?, :assertions, :failures, :time

      def initialize(minitest_result)
        @minitest_result = minitest_result
        @state = MinitestBender.states.fetch(minitest_result.result_code)
      end

      def context
        @context ||= minitest_result.class.name.gsub('::', ' > ')
      end

      def header
        Colorin.white("• #{context}").bold
      end

      def details_header(number)
        "    #{number}#{Colorin.white(context)} > #{name}"
      end

      def rerun_line(padding)
        unformatted = "Rerun: #{rerun_command}"
        "#{padding}#{Colorin.blue_a700(unformatted)}"
      end

      def state?(some_state)
        state.class == some_state.class
      end

      def line_for_slowness_podium
        "#{formatted_time} #{Colorin.white(context)} > #{name}"
      end

      private

      attr_reader :minitest_result, :state

      def formatted_label
        "    #{state.formatted_label}"
      end

      def formatted_message
        " #{state.formatted_message(self)}"
      end

      def formatted_time
        Colorin.grey_700("#{(time * 1000).round}ms ".rjust(6))
      end

      def rerun_command
        relative_location = state.test_location(self).split(':').first
        "rake TEST=#{relative_location} TESTOPTS=\"--name=#{name_for_rerun_command}\""
      end
    end
  end
end