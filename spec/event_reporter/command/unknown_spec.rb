require 'spec_helper'
require_relative '../../../lib/event_reporter/command/unknown'

describe EventReporter::Command::Unknown do
  it "tells the user goodbye" do
    EventReporter::Command::Unknown.new.run.should == "Unknown command, please try again."
  end
end
