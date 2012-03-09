module EventReporter
  module Command
    class Unknown
      # We take an unused argument here simply to implement the proper interface
      # for commands.
      def run(argument=nil)
        "Unknown command, please try again.\n"
      end
    end
  end
end
