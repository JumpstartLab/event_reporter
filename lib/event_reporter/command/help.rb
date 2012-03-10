module EventReporter
  module Command
    class Help
      # We take an unused argument here simply to implement the proper interface
      # for commands.
      def run(arguments)
        command_to_display_help_for = arguments.join(' ')
        case command_to_display_help_for
          when "find"
            <<-__
Load the queue with all records matching the criteria for the given attribute. Example usages:

find zipcode 20011
find last_name Johnson
find state VA
            __
          when 'queue clear'
            "Empty the queue.\n"
          else
            <<-__
exit - End the program.
help - Output a listing of the available individual commands.
help <command> - Display help for an individual command. For example: help find or help queue clear
load - Erase any loaded data and parse the specified file.
find - Find records that match a certain search criteria.
queue - Perform different actions on a queue loaded from a find command.
            __
        end

      end
    end
  end
end
