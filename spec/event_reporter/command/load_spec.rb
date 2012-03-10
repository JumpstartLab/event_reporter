require 'spec_helper'
require_relative '../../../lib/event_reporter/command/load'

describe EventReporter::Command::Load do
  context "with a provided file name" do
    it "loads the file and returns the name of the file being loaded" do
      file_name = 'my_file.cvs'
      EventManager.instance.should_receive(:load_file).with(file_name)
      EventReporter::Command::Load.new.run([file_name]).should == "Loading file: #{file_name}\n"
    end
  end

  context "without a provided file name" do
    it "loads the file and returns event_attendees.csv as the loaded file" do
      file_name = 'event_attendees.csv'
      EventManager.instance.should_receive(:load_file).with(file_name)
      EventReporter::Command::Load.new.run([]).should == "Loading file: #{file_name}\n"
    end
  end

end
