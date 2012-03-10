require 'spec_helper'
require_relative '../lib/event_manager'

describe EventManager do
  subject { EventManager.instance }
  describe "loading a file" do
    it "erases any previously loaded searches" do
      sample_file_name = File.expand_path('../fixture_files/sample_event_attendees.csv', __FILE__)
      subject.load_file(sample_file_name)
      subject.find(:zipcode, '20010')
      # We know that it found something in the search
      subject.print_queue.should =~ /20010/

      subject.load_file(sample_file_name)
      subject.print_queue.should_not =~ /20010/

    end
  end

  describe "finding and printing queue" do
    context "after a search" do
      it "outputs headers and the results of the query" do
        sample_file_name = File.expand_path('../fixture_files/sample_event_attendees.csv', __FILE__)
        subject.load_file(sample_file_name)
        subject.find(:zipcode, '20010')

        expected_output = "LAST NAME\tFIRST NAME\tEMAIL\tZIPCODE\tCITY\tSTATE\tADDRESS\nNguyen\tAllison\tarannon@jumpstartlab.com\t20010\tWashington\tDC\t3155 19th St NW"

        subject.print_queue.should == expected_output
      end
    end
    context "with an invalid search field" do
      it "raises a EventManager::InvalidFieldError" do
        sample_file_name = File.expand_path('../fixture_files/sample_event_attendees.csv', __FILE__)
        subject.load_file(sample_file_name)

        expect { subject.find(:foo, '20010') }.to raise_error EventManager::InvalidFieldError
      end
    end
    context "when called before a search is performed" do
      it "only prints out the headers" do
        sample_file_name = File.expand_path('../fixture_files/sample_event_attendees.csv', __FILE__)
        subject.load_file(sample_file_name)

        expected_output = "LAST NAME\tFIRST NAME\tEMAIL\tZIPCODE\tCITY\tSTATE\tADDRESS\n"

        subject.print_queue.should == expected_output
      end
    end
  end
end
