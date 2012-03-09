require 'spec_helper'
require_relative '../../lib/event_reporter/cli'

# This is here to quickly get around the
# limitation that gets is a private method on Object.
# This prevents me from using a simple Object.new or
# RSpec mock.
class MockInput
  def gets
  end
end

describe EventReporter::Cli do
  it "gets a command from the user and runs the command" do
    output = []
    input = MockInput.new
    command_from_user = 'exit'
    input.stub(:gets) { command_from_user }
    command = double("command")

    cli = EventReporter::Cli.new(input, output)

    EventReporter::CommandFactory.stub(:get).with(command_from_user) { command }
    command.should_receive(:run)

    cli.start
  end

end
