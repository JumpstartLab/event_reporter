require 'spec_helper'
require_relative '../../lib/event_reporter/command_factory'

describe EventReporter::CommandFactory do
  it "returns an exit command based" do
    EventReporter::CommandFactory.get('exit').should be_a EventReporter::Command::Exit
  end

  it "knows about the help command" do
    EventReporter::CommandFactory.get('help').should be_a EventReporter::Command::Help
  end

  it "returns an unknown command if the command is not known" do
    EventReporter::CommandFactory.get('yo').should be_a EventReporter::Command::Unknown
  end
end
