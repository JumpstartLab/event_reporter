# Load up all of the command files
Dir[File.dirname(__FILE__) + '/command/*.rb'].map { |f| require f }

module EventReporter
  class CommandFactory
    def self.get(command)
      begin
        EventReporter::Command.const_get(command.capitalize).new
      rescue NameError
        EventReporter::Command::Unknown.new
      end
    end
  end
end
