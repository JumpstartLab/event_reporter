module EventReporter
  module Command
    class Help
      # We take an unused argument here simply to implement the proper interface
      # for commands.
      def run(argument=nil)
        <<-__
exit - End the program.
help - Output a listing of the available individual commands.
load - Erase any loaded data and parse the specified file.
        __
      end
    end
  end
end
