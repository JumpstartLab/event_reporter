module EventReporter
  module Command
    class Exit
      # We take an unused argument here simply to implement the proper interface
      # for commands.
      def run(arguments)
        "Goodbye!\n"
      end
    end
  end
end
