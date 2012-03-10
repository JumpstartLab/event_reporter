# Load up all of the command files
Dir[File.dirname(__FILE__) + '/command/*.rb'].map {|f| require f}

module EventReporter
  class CommandFactory
    def self.get(command)
      case command
        when 'exit'
          EventReporter::Command::Exit.new
        when 'help'
          EventReporter::Command::Help.new
        when 'find'
          EventReporter::Command::Find.new
        when 'load'
          EventReporter::Command::Load.new
        when 'queue'
          EventReporter::Command::Queue.new
        else
          EventReporter::Command::Unknown.new
      end
    end
  end
end
