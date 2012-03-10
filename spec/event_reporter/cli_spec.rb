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
  let(:output) { [] }
  let(:input) { MockInput.new }
  let(:command) { double("command") }
  let(:cli) { EventReporter::Cli.new(input, output) }

  # I test both here because I need the exit command to end the loop.
  it "knows how to deal with commands that both take arguments and do not take arguments" do
    command_from_user = 'load'
    command_arguments = 'my_file.csv'

    input.stub(:gets).and_return([command_from_user, command_arguments].join(' '), 'exit')

    EventReporter::CommandFactory.should_receive(:get).once.with(command_from_user) { command }
    EventReporter::CommandFactory.should_receive(:get).once.with('exit') { command }

    command.should_receive(:run).with([command_arguments])
    command.should_receive(:run).with([])

    cli.start
  end

end
