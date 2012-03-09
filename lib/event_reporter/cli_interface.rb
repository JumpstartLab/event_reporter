require_relative './command_factory'

module EventReporter
  class Cli
    def start
      command = nil
      while command != 'exit'
        puts "Please enter a command (type 'help' for a list of commands):"
        command = gets.chomp
        puts "\n"
        command_instance = EventReporter::CommandFactory.get(command)
        puts command_instance.run
        puts "\n"
      end

    end
  end
end
