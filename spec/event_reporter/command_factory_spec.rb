require 'spec_helper'
require_relative '../../lib/event_reporter/command_factory'

describe EventReporter::CommandFactory do
  it "returns an exit command based" do
    command = EventReporter::CommandFactory.get('exit')
    command.should be_a EventReporter::Command::Exit
  end

  it "knows about the help command" do
    command = EventReporter::CommandFactory.get('help')
    command.should be_a EventReporter::Command::Help
  end

  it "returns an unknown command if the command is not known" do
    command = EventReporter::CommandFactory.get('yo')
    command.should be_a EventReporter::Command::Unknown
  end
end
