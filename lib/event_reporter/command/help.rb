module EventReporter
  module Command
    class Help
      def run
        <<-__
exit - End the program.
help - Output a listing of the available individual commands.
        __

      end
    end
  end
end
