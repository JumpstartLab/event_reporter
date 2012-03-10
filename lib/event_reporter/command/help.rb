module EventReporter
  module Command
    class Help
      # We take an unused argument here simply to implement the proper interface
      # for commands.
      def run(arguments)
        <<-__
exit - End the program.
help - Output a listing of the available individual commands.
load - Erase any loaded data and parse the specified file.
find - Find records that match a certain search criteria.
queue - Perform different actions on a queue loaded from a find command.
        __
      end
    end
  end
end
