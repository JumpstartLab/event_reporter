module EventReporter
  module Command
    class Exit
      # We take an unused argument here simply to implement the proper interface
      # for commands.
      def run(argument=nil)
        "Goodbye!\n"
      end
    end
  end
end
