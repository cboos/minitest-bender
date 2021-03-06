# coding: utf-8
# frozen_string_literal: true

module MinitestBender
  module States
    class Failing < Base
      COLOR = :red_500
      LABEL = 'FAILED'
      GROUP_LABEL = 'FAILURES'
      ICON = '✖'

      def formatted_message(result)
        @formatted_message ||= colored(location(result))
      end

      def summary_message(results)
        filtered_results = only_with_this_state(results)
        return '' if filtered_results.empty?
        colored("#{filtered_results.size} failed")
      end
    end
  end
end
