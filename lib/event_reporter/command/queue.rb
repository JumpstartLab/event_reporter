module EventReporter
  module Command
    class Queue
      def run(arguments)
        queue_command = arguments[0]
        case queue_command
          when 'print'
            EventManager.instance.print_queue
        end
      end
    end
  end
end
