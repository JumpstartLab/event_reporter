require_relative './command_factory'

module EventReporter
  class Cli
    def initialize(input_stream, output_stream)
      @input_stream = input_stream
      @output_stream = output_stream
    end

    def start
      command = nil
      while command != 'exit'
        @output_stream << "Please enter a command (type 'help' for a list of commands): "
        input_from_user = @input_stream.gets.chomp
        command, *command_arguments = input_from_user.split(' ')

        @output_stream << "\n"
        command_instance = EventReporter::CommandFactory.get(command)
        @output_stream << command_instance.run(command_arguments)
        @output_stream << "\n"
      end
    end
  end
end
