module EventReporter
  module Command
    class Load
      def run(file_name='event_attendees.csv')
        "Loading file: #{file_name}\n"
      end
    end
  end
end
