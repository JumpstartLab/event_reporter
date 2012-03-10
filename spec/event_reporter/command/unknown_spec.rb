require 'spec_helper'
require_relative '../../../lib/event_reporter/command/unknown'

describe EventReporter::Command::Unknown do
  it "tells the user goodbye" do
    expected_output = "Unknown command, please try again.\n"
    EventReporter::Command::Unknown.new.run([]).should == expected_output
  end
end
