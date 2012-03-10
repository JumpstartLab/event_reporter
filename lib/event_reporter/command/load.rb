require_relative '../../../lib/event_manager'

module EventReporter
  module Command
    class Load
      def run(arguments)
        file_name = arguments[0] || 'event_attendees.csv'
        begin
          EventManager.instance.load_file(file_name)
          "Loading file: #{file_name}\n"
        rescue Errno::ENOENT
          "File not found: #{file_name}\n"
        end
      end
    end
  end
end
