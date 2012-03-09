require 'spec_helper'
require_relative '../../../lib/event_reporter/command/help'

describe EventReporter::Command::Help do
  it "lists the available commands" do
    expected_output = <<-__
exit - End the program.
help - Output a listing of the available individual commands.
load - Erase any loaded data and parse the specified file.
__
    EventReporter::Command::Help.new.run.should == expected_output
  end
end
