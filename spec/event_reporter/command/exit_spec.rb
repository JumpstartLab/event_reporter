require 'spec_helper'
require_relative '../../../lib/event_reporter/command/exit'

describe EventReporter::Command::Exit do
  it "tells the user goodbye" do
    EventReporter::Command::Exit.new.run.should == "Goodbye!\n"
  end
end
