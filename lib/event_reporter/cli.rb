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
        command = @input_stream.gets.chomp

        @output_stream << "\n"
        command_instance = EventReporter::CommandFactory.get(command)
        @output_stream << command_instance.run
        @output_stream << "\n"
      end
    end
  end
end
