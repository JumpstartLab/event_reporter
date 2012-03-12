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

  it "knows about the load command" do
    command = EventReporter::CommandFactory.get('load')
    command.should be_a EventReporter::Command::Load
  end

  it "knows about the find command" do
    command = EventReporter::CommandFactory.get('find')
    command.should be_a EventReporter::Command::Find
  end

  it "knows about the queue command" do
    command = EventReporter::CommandFactory.get('queue')
    command.should be_a EventReporter::Command::Queue
  end

  it "returns an unknown command if the command is not known" do
    command = EventReporter::CommandFactory.get('yo')
    command.should be_a EventReporter::Command::Unknown
  end
end