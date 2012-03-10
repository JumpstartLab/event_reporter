require 'spec_helper'
require_relative '../lib/event_manager'

describe EventManager do

  describe "#print_queue" do
    let(:manager) { EventManager.instance }
    context "after a search" do
      it "outputs headers and the results of the query" do
        sample_file_name = File.expand_path('../fixture_files/sample_event_attendees.csv', __FILE__)
        manager.load_file(sample_file_name)
        manager.find(:zipcode, '20010')

        expected_output = "LAST NAME\tFIRST NAME\tEMAIL\tZIPCODE\tCITY\tSTATE\tADDRESS\nNguyen\tAllison\tarannon@jumpstartlab.com\t20010\tWashington\tDC\t3155 19th St NW"

        manager.print_queue.should == expected_output
      end
    end
    context "with an invalid search field" do
      it "only prints out the headers" do
        sample_file_name = File.expand_path('../fixture_files/sample_event_attendees.csv', __FILE__)
        manager.load_file(sample_file_name)
        manager.find(:foo, '20010')

        expected_output = "LAST NAME\tFIRST NAME\tEMAIL\tZIPCODE\tCITY\tSTATE\tADDRESS\n"

        manager.print_queue.should == expected_output
      end
    end
    context "when called before a search is performed" do
      it "only prints out the headers" do
        sample_file_name = File.expand_path('../fixture_files/sample_event_attendees.csv', __FILE__)
        manager.load_file(sample_file_name)

        expected_output = "LAST NAME\tFIRST NAME\tEMAIL\tZIPCODE\tCITY\tSTATE\tADDRESS\n"

        manager.print_queue.should == expected_output
      end
    end
  end
end
