require 'spec_helper'
require_relative '../lib/event_manager'

describe EventManager do
  #describe "#instance" do
  #  it "returns me an instance of the event manager" do
  #    EventManager.instance.should be_a EventManager
  #  end
  #
  #  it "returns me the same instance of the event manager" do
  #    EventManager.instance.should == EventManager.instance
  #  end
  #end

  describe "#find" do
    it "allows me to query against last name and print the query" do
      manager = EventManager.new
      sample_file_name = File.expand_path('../fixture_files/sample_event_attendees.csv', __FILE__)
      manager.load_file(sample_file_name)
      manager.find(:zipcode, '20010')

      expected_output = "LAST NAME\tFIRST NAME\tEMAIL\tZIPCODE\tCITY\tSTATE\tADDRESS\nNguyen\tAllison\tarannon@jumpstartlab.com\t20010\tWashington\tDC\t3155 19th St NW"

      manager.print_queue.should == expected_output
    end

    it "does not print any results if the field is not valid" do
      manager = EventManager.new
      sample_file_name = File.expand_path('../fixture_files/sample_event_attendees.csv', __FILE__)
      manager.load_file(sample_file_name)
      manager.find(:foo, '20010')

      expected_output = "LAST NAME\tFIRST NAME\tEMAIL\tZIPCODE\tCITY\tSTATE\tADDRESS\n"

      manager.print_queue.should == expected_output
    end
  end
end
