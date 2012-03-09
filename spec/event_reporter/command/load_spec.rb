require 'spec_helper'
require_relative '../../../lib/event_reporter/command/load'

describe EventReporter::Command::Load do
  it "returns the name of the file being loaded" do
    file_name = 'my_file.cvs'
    EventReporter::Command::Load.new.run(file_name).should == "Loading file: #{file_name}\n"
  end
  it "loads the file event_attendees.csv file if not given a file" do
    file_name = 'event_attendees.csv'
    EventReporter::Command::Load.new.run.should == "Loading file: #{file_name}\n"

  end
end
