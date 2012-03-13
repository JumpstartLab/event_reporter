module EventReporter
  module Command
    class Queue
      def run(arguments)
        queue_command = arguments[0]
        case queue_command
          when 'print'
            if arguments[1]  == 'by'
              EventManager.instance.print_queue(arguments[2].to_sym)
            else
              EventManager.instance.print_queue
            end
          when 'clear'
            EventManager.instance.clear_queue
            "Queue cleared.\n"
          when 'count'
            queue_count = EventManager.instance.count_queue
            "There are #{queue_count} items in the queue.\n"
          else
            "Invalid command for the queue.\n"
        end
      end
    end
  end
end
